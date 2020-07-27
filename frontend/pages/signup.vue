<template lang="pug">

div
  h3 Sign Up
  v-form(@submit.prevent='signup')
    v-alert(v-if='error') {{ error }}
    v-text-field(v-model="email" label="E-mail adress")
    v-text-field(v-model="password" label="Password" type="password")
    v-text-field(v-model="password_confirmation" label="Password confirmation" type="password")
    v-btn(type='submit') Sign Up
    .my-4
      nuxt-link(to='/') Sign In
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      password_confirmation: '',
      error: ''
    }
  },
  created () {
    this.checkedSignedIn()
  },
  updated () {
    this.checkedSignedIn()
  },
  methods: {
    signup () {
      this.$plain.post('/signup', {
        email: this.email, password: this.password, password_confirmation: this.password_confirmation
      })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }

      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/records')
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkedSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/records')
      }
    }
  }
}
</script>
