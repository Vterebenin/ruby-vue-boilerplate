<template lang="pug">
  v-app-bar(app color="white")
    v-app-bar-nav-icon
      logo
    v-toolbar-title(to="/") RecordStore
    v-spacer
    v-toolbar-items
      v-btn(text v-if="!signedIn" to="/") Sign in
      v-btn(text v-if="!signedIn" to="/signup") Sign Up
      v-btn(text v-if="signedIn" to="/records") Records
      v-btn(text v-if="signedIn" to="/artists") Artists
      v-btn(text v-if="signedIn" href="#" @click.prevent="signOut") Sign out
</template>

<script>
import Logo from '~/components/Logo'

export default {
  name: 'Header',
  components: { Logo },
  computed: {
    signedIn () {
      return localStorage.getItem('signedIn')
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    signOut () {
      this.$secured.delete('/signin')
        .then((response) => {
          localStorage.removeItem('signedIn')
          localStorage.removeItem('csrf')
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    }
  }
}
</script>
