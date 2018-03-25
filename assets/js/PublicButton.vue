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
    axios.get('/options/is-public-access').then(function (response) {
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
        return "Currently anyone with internet access can visit the site and view and play CIPs. If you disable this option, only users with accounts above will be able to access the site."
      } else {
        return "Only users with accounts listed above will be able to access the site. The general public will be confronted with a log in screen to which they do not have access."
      }
    },
    buttonText() {
      if (this.isEnabled) {
        return "Make Private"
      } else {
        return "Make Public"
      }
    },
    statusText() {
      return this.isEnabled ? "Public Access Allowed" : "Private Access Only"
    }
  },
  methods: {
    toggle() {
      this.isToggling = true
      var self = this

      axios.put('/options/is-public-access', {
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
