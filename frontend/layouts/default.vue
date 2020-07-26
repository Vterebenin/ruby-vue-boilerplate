<template>
  <v-app dark>
    <Header />
    <v-content>
      <v-container>
        <nuxt />
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
import Header from '~/components/Header.vue'

export default {
  name: 'DefaultLayout',
  components: { Header }
}
</script>
