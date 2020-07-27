<template lang="pug">
  div
    v-row
      v-col
        h3 Sign in
    v-row
      v-col
        v-form(@submit.prevent="signin")
          v-alert(type="error" v-if="error") {{ error }}
          v-text-field(v-model="email" label="E-mail Address")
          v-text-field(v-model="password" label="Password" type="password")
          v-btn(type="submit") Sign in
    v-row
      v-col
        nuxt-link(to="/signup" class="link-grey") Sign up
</template>
<script>
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin () {
      this.$plain.post('/signin', { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      localStorage.setItem('csrf', response.data.csrf)
      localStorage.setItem('signedIn', true)
      this.error = ''
      this.$router.replace('/records')
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      localStorage.removeItem('signedIn')
      localStorage.removeItem('csrf')
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/records')
      }
    }
  }
}
</script>
