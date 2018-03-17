<template>
  <div class="invite-box">
    <div v-if="!isInviting">
      <div v-if="!isInvited">
        <button class="uk-button uk-button-default uk-button-small" v-on:click="invite(user.id)">Invite</button>
      </div>
      <div v-else>
        <button class="uk-button uk-button-secondary color-green uk-button-small"
          title="Resend" v-on:click="invite(user.id)" uk-tooltip="pos: left">Sent</button>
      </div>
    </div>
    <div v-else>
      <button class="uk-button uk-button-default uk-button-small" disabled>Sending</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  //name: 'main',
  props: ["user"],
  data () {
    return {
      isInviting: false,
      isInvited: this.user.is_invited
    }
  },
  methods: {
    invite(id) {
      this.isInviting = true
      var self = this
      axios.post('/users/'+id, {
        _csrf_token: CSRF
      }).then(function (response) {
        if (response.data.error) {
          alert('server error. contact sys admin.')
        } else {
          self.isInvited = true
          self.isInviting = false
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
.invite-box {
  min-width: 100px;
  text-align: center;
}
</style>
