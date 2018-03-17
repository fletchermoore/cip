<template>
  <div v-if="isLoaded">
    <p>
      <b class="uk-margin-right" :style="{ color: this.isEnabled ? '#00cc00' : 'red'}">{{ statusText }}</b>
      <button v-if="!isToggling" class="uk-button uk-button-default" v-on:click="toggle">{{ buttonText }}</button>
      <button v-else class="uk-button uk-button-default" disabled>Updating</button>
    </p>
    <p>{{ explanationText }}</p>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  //name: 'main',
  props: ["user"],
  data () {
    return {
      isEnabled: false,
      isToggling: false,
      isLoaded: false
    }
  },
  mounted() {
    var self = this
    axios.get('/options/is-site-enabled').then(function (response) {
      if (response.data.data && response.data.data.value) {
        self.isEnabled = response.data.data.value == "true" ? true : false
        self.isLoaded = true
      } else {
        alert('server error. contact sys admin.')
      }
    })
    .catch(function (error) {
      alert('network error. contact sys admin.');
    });
  },
  computed: {
    explanationText() {
      if (this.isEnabled) {
        return "If you disable the site, only administrators will be able to log in. Currently any user can log in."
      } else {
        return "Currently only administrators can log in. You must enable the site to allow users to log in and play the CIPs."
      }
    },
    buttonText() {
      if (this.isEnabled) {
        return "Disable Site"
      } else {
        return "Enable Site"
      }
    },
    statusText() {
      return this.isEnabled ? "Site Enabled" : "Site Disabled"
    }
  },
  methods: {
    toggle() {
      this.isToggling = true
      var self = this

      axios.put('/options/is-site-enabled', {
        value: '' + !self.isEnabled,
        _csrf_token: CSRF
      }).then(function (response) {
        if (response.data.data && response.data.data.value) {
          self.isToggling = false
          self.isEnabled = response.data.data.value == "true" ? true : false
        } else {
          alert('server error. contact sys admin.')
        }
      })
      .catch(function (error) {
        alert('network error. contact sys admin.');
      });
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.color-green {
  background-color: #00cc00
}
</style>
