<template>
  <header class="bg-grey-lighter py-4">
    <div class="container m-auto flex flex-wrap items-center justify-end">
      <div class="flex-1 flex items-center">
        <svg class="fill-current text-indigo" viewBox="0 0 24 24" width="24" height="24"><title>record vinyl</title><path d="M23.938 10.773a11.915 11.915 0 0 0-2.333-5.944 12.118 12.118 0 0 0-1.12-1.314A11.962 11.962 0 0 0 12 0C5.373 0 0 5.373 0 12s5.373 12 12 12 12-5.373 12-12c0-.414-.021-.823-.062-1.227zM12 16a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm0-5a1 1 0 1 0 0 2 1 1 0 0 0 0-2z" /></svg>

        <a href="/" class="uppercase text-sm font-mono pl-4 font-semibold no-underline text-indigo-dark hover:text-indigo-darker">Record Store</a>
      </div>
      <div>
        <nuxt-link v-if="!signedIn" to="/" class="link-grey px-2 no-underline">
          Sign in
        </nuxt-link>
        <nuxt-link v-if="!signedIn" to="/signup" class="link-grey px-2 no-underline">
          Sign Up
        </nuxt-link>
        <nuxt-link v-if="signedIn" to="/records" class="link-grey px-2 no-underline">
          Records
        </nuxt-link>
        <nuxt-link v-if="signedIn" to="/artists" class="link-grey px-2 no-underline">
          Artists
        </nuxt-link>
        <a v-if="signedIn" href="#" class="link-grey px-2 no-underline" @click.prevent="signOut">Sign out</a>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'Header',
  computed: {
    signedIn () {
      console.log(localStorage.getItem('signedIn'))
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
