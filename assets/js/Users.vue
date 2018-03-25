<template>
  <div>
    <div class="uk-text-right">
      <label for="hideDeleted">Hide Deleted</label>
      <input type="checkbox" class="uk-checkbox" id="hideDeleted" v-model="hideDeleted"/>
    </div>
    <table class="uk-table uk-table-divider uk-table-small">
      <thead>
        <tr>
          <th>Email</th>
          <th>Role</th>
          <th>Name</th>
          <th style="text-align: center">Invitation</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" v-if="user['is_deleted'] == false || hideDeleted == false" :class="{ greyback: user.is_deleted }">
          <td>
            <div><b>{{ user["email"] }}</b></div>
          </td>
          <td v-if="user.is_admin">
            <span v-if="user.is_admin"><em>Admin</em></span>
          </td>
          <td v-else>
            <span v-if="user.is_control">Control</span>
            <span v-else>Student</span>
          </td>
          <td>
            {{ user["identifier"] }}
          </td>
          <td class="text-right">
            <InviteButton v-if="!user.is_deleted" :user="user" />
            <!-- <button class="uk-button uk-button-default uk-button-small" v-on:click="edit(user)">Edit</button> -->
            <!-- <button class="uk-button uk-button-danger uk-button-small">Disable</button> -->
          </td>
          <td>
            <button v-on:click="editUser(user)" class="uk-button uk-button-small uk-button-default">Edit</button>
            <span v-if="!user.is_admin">
              <button v-if="!user.is_deleted" class="uk-button uk-button-small uk-button-danger" v-on:click="deleteUser(user)">Delete</button>
              <b v-else>Deleted</b>
            </span>
          </td>
        </tr>
      </tbody>
    </table>
    <h3>Create User</h3>
    <p>Once you create a user, you must separately invite them by clicking the invite button in the table above. This will send
      the user an email with their temporary password.</p>
    <form action="/users" method="post" class="uk-form-stacked uk-margin-large-bottom">
      <input type="hidden" name="_csrf_token" :value="csrf" />
      <div uk-grid>
        <div>
          <label class="uk-form-label">Email</label>
          <div class="uk-form-controls">
            <input type="text" name="user[email]" class="uk-input wider-input" />
          </div>
        </div>
        <div>
          <input type="hidden" name="user[is_control]" value="false" />
  <!-- remove experimental/control distinction
          <label class="uk-form-label">Group</label>
          <div class="uk-form-controls">
            <select class="uk-select" name="user[is_control]">
              <option value="true">Control</option>
              <option value="false">Experimental</option>
            </select>
          </div>
  -->
        </div>
        <div>
          <label class="uk-form-label">Name</label>
          <div class="uk-form-controls">
            <input type="text" class="uk-input" name="user[identifier]" />
          </div>
        </div>
        <div style="position: relative">
          <label class="uk-form-label"></label>
          <div class="uk-form-controls" style="position: absolute; bottom: 0">
            <button class="uk-button uk-button-primary">Create</button>
          </div>
        </div>
      </div>
    </form>
    <h3>Public Access</h3>
    <div><PublicButton /></div>
        <!-- This is the user edit modal -->
        <div id="edit-user-modal" uk-modal>
            <div class="uk-modal-dialog uk-modal-body">
                <h2 class="uk-modal-title">Edit User</h2>
                <form class="uk-form-horizontal" id="edit-form" method="post" :action="editAction">
                  <input type="hidden" name="_method" value="put" />
                  <input type="hidden" name="_csrf_token" v-model="csrf" />
                  <p>
                    <label class="uk-form-label">Email</label>
                    <div class="uk-form-controls">
                      <input class="uk-input" type="text" name="user[email]" :value="activeUser.email" />
                    </div>
                  </p>
                  <input type="hidden" name="user[is_control]" value="false" />
  <!-- remove the experimental/control distinction
                  <p>
                    <label class="uk-form-label">Group</label>
                    <div class="uk-form-controls">
                      <select class="uk-select" name="user[is_control]">
                        <option value="true">Control</option>
                        <option value="false" selected="selected" v-if="!activeUser.is_control">Experimental</option>
                        <option value="false" v-else>Experimental</option>
                      </select>
                    </div>
                  </p>
  -->
                  <p>
                    <label class="uk-form-label">Name</label>
                    <div class="uk-form-controls">
                      <input class="uk-input" type="text" name="user[identifier]" :value="activeUser.identifier" />
                    </div>
                  </p>
                  <p>
                    <div v-if="activeUser.is_admin">
                      <label class="uk-form-label">Revoke admin privileges?</label>
                      <div class="uk-form-controls">
                        <label>Yes <input class="uk-radio" type="radio" name="user[is_admin]" value="false" /></label>
                        <label>No <input class="uk-radio" type="radio" name="user[is_admin]" value="true" checked /></label>
                      </div>
                    </div>
                    <div v-else>
                      <label class="uk-form-label">Promote to admin?</label>
                      <div class="uk-form-controls">
                        <label>Yes <input class="uk-radio" type="radio" name="user[is_admin]" value="true" /></label>
                        <label>No <input class="uk-radio" type="radio" name="user[is_admin]" value="false" checked /></label>
                      </div>
                    </div>
                  </p>
                  <p>
                    <div v-if="activeUser.is_deleted">
                      <label class="uk-form-label">Un-delete user?</label>
                      <div class="uk-form-controls">
                        <label>Yes <input class="uk-radio" type="radio" name="user[is_deleted]" value="false" /></label>
                        <label>No <input class="uk-radio" type="radio" name="user[is_deleted]" value="true" checked /></label>
                      </div>
                    </div>
                </form>
                <p class="uk-text-right">
                    <button class="uk-button uk-button-default uk-modal-close" type="button">Cancel</button>
                    <button class="uk-button uk-button-primary" type="button" v-on:click="saveEdits()">Save</button>
                </p>
            </div>
        </div>
  </div>
</template>

<script>
import axios from 'axios'
import InviteButton from "./InviteButton.vue"
import PublicButton from "./PublicButton.vue"
import _ from 'lodash'

export default {
  components: { InviteButton, PublicButton },
  data () {
    return {
      csrf: CSRF,
      users: USERS,
      hideDeleted: true,
      activeUser: false
    }
  },
  computed: {
    editAction() {
      return '/users/'+this.activeUser.id
    }
  },
  methods: {
    deleteUser(user) {
      if (!confirm("Are you sure you want to delete user: "+user["email"]+"?")) return;

      var self = this
      var deletedId = user.id
      var deletedEmail = user.email
      axios.delete('/users/'+user.id, {
        headers: {
          'x-csrf-token': CSRF
        }
      }).then(function (response) {
        if (response.data.ok) {
          alert(deletedEmail + " deleted")
          self.users = _.map(self.users, function(user) {
            if (user.id == deletedId) {
              return Object.assign(user, { "is_deleted": true })
            } else {
              return user
            }
          })
        }
      }).catch(function (response) {
        alert("network or server error")
      })
    },
    editUser(user) {
      this.activeUser = user
      UIkit.modal(document.getElementById('edit-user-modal')).show()
    },
    saveEdits() {
      let form = document.getElementById('edit-form')
      form.submit()
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.wider-input {
  width: 300px;
}
.greyback {
  background-color: #efefef;
}
</style>
