Church.create([
  {id: 1, church_name: 'The Globe Church', email: 'info@globe.church', url: 'https://www.globe.church', city: 'London'},
])

User.create([
  {churches_id: 1,
   first_name: 'James',
   family_name: 'Doc',
   email: 'james@globe.church',
   password: 'password'}
]);


