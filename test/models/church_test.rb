require 'test_helper'

class ChurchTest < ActiveSupport::TestCase
  test "create new church correctly" do
    c = Church.create(
      church_name: 'test church',
      url: 'https://testchurch.com',
      email: 'info@testchurch.com',
      city: 'test city'
    )

    assert c.valid?
    assert_equal 'test-church', c.slug
    assert_not c.verified
  end

  test "default scope should order alphabetically" do
    c = create(:church, church_name: 'BBB')
    create(:church, church_name: 'CCC')
    a = create(:church, church_name: 'AAA')

    chs = Church.all

    assert_equal 3, chs.count
    assert_operator chs.index(a), :<, chs.index(c)
  end

  test "ensure unique email address" do
    create(:church, email: 'info@testchurch.com')
    c = Church.create(
      church_name: 'test church',
      email: 'info@testchurch.com',
      url: 'www.testchurch.com',
      city: 'test city'
    )
    assert_not c.valid?
    assert_equal %i[email], c.errors.keys
  end

  test "ensure unique URL" do
    create(:church, url: 'www.testchurch.com')
    c = Church.create(
      church_name: 'test church',
      email: 'infomation@testchurch.com',
      url: 'www.testchurch.com',
      city: 'test city'
    )
    assert_not c.valid?
    assert_equal %i[url], c.errors.keys
  end
end
