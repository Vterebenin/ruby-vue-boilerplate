<template>
  <div class="max-w-md m-auto py-10">
    <div v-if="error" class="text-red">
      {{ error }}
    </div>
    <h3 class="font-mono font-regular text-3xl mb-4">
      Add a new record
    </h3>
    <form action="" @submit.prevent="addRecord">
      <div class="mb-6">
        <label for="record_title" class="label">Title</label>
        <input
          id="record_title"
          v-model="newRecord.title"
          class="input"
          autofocus
          autocomplete="off"
          placeholder="Type a record name"
        >
      </div>

      <div class="mb-6">
        <label for="record_year" class="label">Year</label>
        <input
          id="record_year"
          v-model="newRecord.year"
          class="input"
          autofocus
          autocomplete="off"
          placeholder="Year"
        >
      </div>

      <div class="mb-6">
        <label for="artist" class="label">Artist</label>
        <select id="artist" v-model="newRecord.artist" class="select">
          <option disabled value="">
            Select an artist
          </option>
          <option v-for="artist in artists" :key="artist.id" :value="artist.id">
            {{ artist.name }}
          </option>
        </select>
        <p class="pt-4">
          Don't see an artist? <router-link class="text-grey-darker underline" to="/artists">
            Create one
          </router-link>
        </p>
      </div>

      <input type="submit" value="Add Record" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center">
    </form>

    <hr class="border border-grey-light my-6">

    <ul class="list-reset mt-4">
      <li v-for="record in records" :key="record.id" class="py-4" :record="record">
        <div class="flex items-center justify-between flex-wrap">
          <div class="flex-1 flex justify-between flex-wrap pr-4">
            <p class="block font-mono font-semibold flex items-center">
              <svg class="fill-current text-indigo w-6 h-6 mr-2" viewBox="0 0 24 24" width="24" height="24"><title>record vinyl</title><path d="M23.938 10.773a11.915 11.915 0 0 0-2.333-5.944 12.118 12.118 0 0 0-1.12-1.314A11.962 11.962 0 0 0 12 0C5.373 0 0 5.373 0 12s5.373 12 12 12 12-5.373 12-12c0-.414-.021-.823-.062-1.227zM12 16a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm0-5a1 1 0 1 0 0 2 1 1 0 0 0 0-2z" /></svg>
              {{ record.title }} &mdash; {{ record.year }}
            </p>
            <p class="block font-mono font-semibold">
              {{ getArtist(record) }}
            </p>
          </div>
          <button
            class="bg-transparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded"
            @click.prevent="editRecord(record)"
          >
            Edit
          </button>

          <button
            class="bg-transparent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
            @click.prevent="removeRecord(record)"
          >
            Delete
          </button>
        </div>

        <div v-if="record == editedRecord">
          <form action="" @submit.prevent="updateRecord(record)">
            <div class="mb-6 p-4 bg-white rounded border border-grey-light mt-4">
              <div class="mb-6">
                <label class="label">Title</label>
                <input v-model="record.title" class="input">
              </div>

              <div class="mb-6">
                <label class="label">Year</label>
                <input v-model="record.year" class="input">
              </div>

              <div class="mb-6">
                <label class="label">Artist</label>
                <select id="artist" v-model="record.artist" class="select">
                  <option v-for="artist in artists" :key="artist.id" :value="artist.id">
                    {{ artist.name }}
                  </option>
                </select>
              </div>

              <input type="submit" value="Update" class="bg-transparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded">
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Records',
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
      const recordArtistValues = this.artists.filter(artist => artist.id === record.artist_id)
      let artist

      recordArtistValues.forEach(function (element) {
        artist = element.name
      })

      return artist
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
