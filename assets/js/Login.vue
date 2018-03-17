<template>
  <div class="uk-margin">
    <a href="#modal-example" uk-toggle>Forgot password?</a>
    <!-- This is the modal -->
    <div id="modal-example" uk-modal>
        <div class="uk-modal-dialog uk-modal-body">
            <h3 class="uk-modal-title">Forgot your password?</h3>
            <p>Don't worry. Enter your email address and we'll send you a new one.</p>
            <div>
              <input type="text" class="uk-input" v-model="email" placeholder="Your email" />
            </div>
            <p class="uk-text-right">
                <button class="uk-button uk-button-default uk-modal-close" type="button">Cancel</button>
                <button class="uk-button uk-button-primary" type="button" v-on:click.prevent="send()">Send</button>
            </p>
        </div>
    </div>
    <!-- This is the modal with the default close button -->
    <div id="modal-close-default" uk-modal>
        <div class="uk-modal-dialog uk-modal-body">
            <button class="uk-modal-close-default" type="button" uk-close></button>
            <h3 class="uk-modal-title">New password sent</h3>
            <p>Check your inbox.</p>
        </div>
    </div>

    <!-- This is the modal with the default close button -->
    <div id="modal-not-found" uk-modal>
        <div class="uk-modal-dialog uk-modal-body">
            <button class="uk-modal-close-default" type="button" uk-close></button>
            <h3 class="uk-modal-title">Email not found</h3>
            <p>Did you enter your email correctly? If so, you may need to contact your professor
              to ensure your account has been set up.</p>
        </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  //name: 'main',
  data () {
    return {
      email: ""
    }
  },
  methods: {
    send() {
      var email = this.email
      UIkit.modal(document.getElementById('modal-example')).hide()

      axios.post('/reset', {
        _csrf_token: CSRF,
        email: email
      }).then(function (response) {
        if (response.data.error) {
          UIkit.modal(document.getElementById('modal-not-found')).show()
        } else {
          UIkit.modal(document.getElementById('modal-close-default')).show()
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

</style>
