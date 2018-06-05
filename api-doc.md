# One21 API documentation / plans

## GET `/church`

Status: planned

Returns list of churches within One21

```
[
  {
    name: 'Church Name',
    logo: 'https://…',
    slug: 'church-name'
  },
  {...}
]
```
## GET `/church/{slug}`

Status: planned

Returns specific details about a specific church

```
{
  name: 'Church Name',
  sermons: true,
  guides: true,
  logo: 'https://…',
  banner_image: {
    320: 'https://…',
    640: 'https://…',
  }
}
```

`sermons`: Boolean - does the church produce sermon questions to accompany their services?   
`guides`: Boolean - has the church opted in to provide other guides through One21?

## GET `/church/{slug}/guides`

Status: partial implementation

```
[
    {
        name: ‘Hero’,
        slug: ‘hero’,
        promote: true,
        banner_image: {
            320: ‘...’,
            640: ‘...’
        }
    }
    ...
]
```

## GET `/church/{slug}/guide/{guide-slug}`

Status: planned

## GET `/church/{slug}/guide/sermons`

Status: planned
