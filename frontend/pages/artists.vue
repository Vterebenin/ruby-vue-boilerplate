<template lang="pug">
div
  v-alert(v-if='error') {{ error }}
  h3 Add a new artist
  v-form(@submit.prevent='addArtist')
    .mb-6
      v-text-field(v-model="newArtist.name" label="Type an artist name")
      v-btn(type="submit" text)  Add artist
  v-divider
  v-list
    template(v-for="artist in artists")
      v-list-item
        v-list-item-avatar
          svg.fill-current.text-indigo.w-6.h-6.mr-2(viewbox='0 0 20 20' width='20' height='20')
            title music artist
            path(d='M15.75 8l-3.74-3.75a3.99 3.99 0 0 1 6.82-3.08A4 4 0 0 1 15.75 8zm-13.9 7.3l9.2-9.19 2.83 2.83-9.2 9.2-2.82-2.84zm-1.4 2.83l2.11-2.12 1.42 1.42-2.12 2.12-1.42-1.42zM10 15l2-2v7h-2v-5z')
        v-list-item-content
          v-list-item-title {{ artist.name }}
        v-list-item-actions
          v-btn(@click.prevent="editArtist(artist)") Edit
          v-btn(@click.prevent="removeArtist(artist)") Delete
      template(v-if='artist == editedArtist')
        v-form(@submit.prevent='updateArtist(artist)')
          .mb-6
            v-text-field(v-model="artist.name" label="Artist name")
            v-btn(type="submit" text)  Update
</template>

<script>
export default {
  name: 'Artists',
  data () {
    return {
      artists: [],
      newArtist: [],
      error: '',
      editedArtist: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$secured.get('/api/v1/artists')
        .then((response) => { this.artists = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addArtist () {
      const value = this.newArtist
      if (!value) {
        return
      }
      this.$secured.post('/api/v1/artists/', { artist: { name: this.newArtist.name } })

        .then((response) => {
          this.artists.push(response.data)
          this.newArtist = ''
        })
        .catch(error => this.setError(error, 'Cannot create artist'))
    },
    removeArtist (artist) {
      this.$secured.delete(`/api/v1/artists/${artist.id}`)
        .then((response) => {
          this.artists.splice(this.artists.indexOf(artist), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete artist'))
    },
    editArtist (artist) {
      this.editedArtist = artist
    },
    updateArtist (artist) {
      this.editedArtist = ''
      this.$secured.patch(`/api/v1/artists/${artist.id}`, { artist: { name: artist.name } })
        .catch(error => this.setError(error, 'Cannot update artist'))
    }
  }
}
</script>
