<template lang="pug">
div
  v-alert(v-if='error')
    | {{ error }}
  h3.font-mono.font-regular.text-3xl.mb-4
    | Add a new record
  v-form(@submit.prevent='addRecord')
    v-text-field(v-model="newRecord.title" label="Title")
    v-text-field(v-model="newRecord.year" label="Year")
    v-select(v-model="newRecord.artist" label="Select an artist" item-value="id" item-text="name" :items="artists")
    p.pb-4 Don&apos;t see an artist?
      nuxt-link(to='/artists') Create one
    v-btn.mb-5(type="submit" color="black" dark) Add Record
  v-divider
  v-list
    template(v-for="record in records")
      v-list-item
        v-list-item-avatar
          logo
        v-list-item-content
          v-list-item-title {{ record.title }} &mdash; {{ record.year }}
          v-list-item-subtitle {{ getArtist(record) }}
        v-list-item-action
          v-btn(@click.prevent="editRecord(record)" text) Edit
          v-btn(@click.prevent="removeRecord(record)" text) Delete
      template(v-if='record == editedRecord')
        v-form(@submit.prevent='updateRecord(record)')
          v-text-field(v-model="record.title" label="Title")
          v-text-field(v-model="record.year" label="Year")
          v-select(v-model="record.artist_id" label="Select an artist" item-value="id" item-text="name" :items="artists")
          v-btn(type="submit" text) Update
</template>

<script>
import Logo from '~/components/Logo'

export default {
  name: 'Records',
  components: { Logo },
  data () {
    return {
      artists: [],
      records: [],
      newRecord: [],
      error: '',
      editedRecord: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$secured.get('/api/v1/records')
        .then((response) => { this.records = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))

      this.$secured.get('/api/v1/artists')
        .then((response) => { this.artists = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    getArtist (record) {
      const artist = this.artists.find(artist => artist.id === record.artist_id)

      return (artist && artist.name) || ''
    },
    addRecord () {
      const value = this.newRecord
      if (!value) {
        return
      }
      this.$secured.post('/api/v1/records/', { record: { title: this.newRecord.title, year: this.newRecord.year, artist_id: this.newRecord.artist } })

        .then((response) => {
          this.records.push(response.data)
          this.newRecord = ''
        })
        .catch(error => this.setError(error, 'Cannot create record'))
    },
    removeRecord (record) {
      this.$secured.delete(`/api/v1/records/${record.id}`)
        .then((response) => {
          this.records.splice(this.records.indexOf(record), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete record'))
    },
    editRecord (record) {
      this.editedRecord = record
    },
    updateRecord (record) {
      this.editedRecord = ''
      this.$secured.patch(`/api/v1/records/${record.id}`, { record: { title: record.title, year: record.year, artist_id: record.artist } })
        .catch(error => this.setError(error, 'Cannot update record'))
    }
  }
}
</script>
