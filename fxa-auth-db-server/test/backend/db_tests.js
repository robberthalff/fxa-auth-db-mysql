/* Any copyright is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/ */

var test = require('tap').test
var crypto = require('crypto')

var zeroBuffer16 = Buffer('00000000000000000000000000000000', 'hex')
var zeroBuffer32 = Buffer('0000000000000000000000000000000000000000000000000000000000000000', 'hex')
var now = Date.now()

function newUuid() {
  return crypto.randomBytes(16)
}

function createAccount() {
  var account = {
    uid: newUuid(),
    email: ('' + Math.random()).substr(2) + '@bar.com',
    emailCode: zeroBuffer16,
    emailVerified: false,
    verifierVersion: 1,
    verifyHash: zeroBuffer32,
    authSalt: zeroBuffer32,
    kA: zeroBuffer32,
    wrapWrapKb: zeroBuffer32,
    verifierSetAt: now,
    createdAt: now,
    locale : 'en_US',
  }
  account.normalizedEmail = account.email.toLowerCase()
  return account
}


var ACCOUNT = createAccount()

function hex(len) {
  return Buffer(crypto.randomBytes(len).toString('hex'), 'hex')
}
function hex16() { return hex(16) }
function hex32() { return hex(32) }
// function hex64() { return hex(64) }
function hex96() { return hex(96) }

var SESSION_TOKEN_ID = hex32()
var SESSION_TOKEN = {
  data : hex32(),
  uid : ACCOUNT.uid,
  createdAt : now + 1,
  uaBrowser : 'mock browser',
  uaBrowserVersion : 'mock browser version',
  uaOS : 'mock OS',
  uaOSVersion : 'mock OS version',
  uaDeviceType : 'mock device type'
}

var KEY_FETCH_TOKEN_ID = hex32()
var KEY_FETCH_TOKEN = {
  authKey : hex32(),
  uid : ACCOUNT.uid,
  keyBundle : hex96(),
  createdAt: now + 2
}

var PASSWORD_FORGOT_TOKEN_ID = hex32()
var PASSWORD_FORGOT_TOKEN = {
  data : hex32(),
  uid : ACCOUNT.uid,
  passCode : hex16(),
  tries : 1,
  createdAt: now + 3
}

var PASSWORD_CHANGE_TOKEN_ID = hex32()
var PASSWORD_CHANGE_TOKEN = {
  data : hex32(),
  uid : ACCOUNT.uid,
  createdAt: now + 4
}

var ACCOUNT_RESET_TOKEN_ID = hex32()
var ACCOUNT_RESET_TOKEN = {
  data : hex32(),
  uid : ACCOUNT.uid,
  createdAt: now + 5
}

// To run these tests from a new backend, pass the config and an already created
// DB API for them to be run against.
module.exports = function(config, DB) {
  DB.connect(config)
    .then(
      function (db) {

        test(
          'ping',
          function (t) {
            t.plan(1)
            return db.ping()
            .then(function(account) {
              t.pass('Got the ping ok')
            }, function(err) {
              t.fail('Should not have arrived here')
            })
          }
        )

        test(
          'account creation and password checking',
          function (t) {
            t.plan(42)
            var emailBuffer = Buffer(ACCOUNT.email)
            return db.accountExists(emailBuffer)
            .then(function(exists) {
              t.fail('account should not yet exist for this email address')
            }, function(err) {
              t.pass('ok, account could not be found')
            })
            .then(function() {
              return db.createAccount(ACCOUNT.uid, ACCOUNT)
            })
            .then(function(account) {
              t.deepEqual(account, {}, 'Returned an empty object on account creation')
              var emailBuffer = Buffer(ACCOUNT.email)
              return db.accountExists(emailBuffer)
            })
            .then(function(exists) {
              t.ok(exists, 'account exists for this email address')
            })
            .then(function() {
              t.pass('Retrieving account using uid')
              return db.account(ACCOUNT.uid)
            })
            .then(function(account) {
              t.deepEqual(account.uid, ACCOUNT.uid, 'uid')
              t.equal(account.email, ACCOUNT.email, 'email')
              t.deepEqual(account.emailCode, ACCOUNT.emailCode, 'emailCode')
              t.equal(!!account.emailVerified, ACCOUNT.emailVerified, 'emailVerified')
              t.deepEqual(account.kA, ACCOUNT.kA, 'kA')
              t.deepEqual(account.wrapWrapKb, ACCOUNT.wrapWrapKb, 'wrapWrapKb')
              t.notOk(account.verifyHash, 'verifyHash field should be absent')
              t.deepEqual(account.authSalt, ACCOUNT.authSalt, 'authSalt')
              t.equal(account.verifierVersion, ACCOUNT.verifierVersion, 'verifierVersion')
              t.equal(account.createdAt, ACCOUNT.createdAt, 'createdAt')
              t.equal(account.verifierSetAt, account.createdAt, 'verifierSetAt has been set to the same as createdAt')
              t.equal(account.locale, ACCOUNT.locale, 'locale')
              t.equal(account.lockedAt, null, 'lockedAt is not set to anything')
            })
            .then(function() {
              t.pass('Checking bad password')
              return db.checkPassword(ACCOUNT.uid, {verifyHash: Buffer(crypto.randomBytes(32))})
            })
            .then(function() {
              t.fail('password check should fail')
            }, function(err) {
              t.ok(err, 'incorrect password produces an error')
              t.equal(err.code, 400, 'error code')
              t.equal(err.errno, 103, 'error errno')
              t.equal(err.message, 'Incorrect password', 'message')
              t.equal(err.error, 'Bad request', 'error')
            })
            .then(function() {
              t.pass('Checking password')
              return db.checkPassword(ACCOUNT.uid, {verifyHash: zeroBuffer32})
            })
            .then(function(account) {
              t.deepEqual(account.uid, ACCOUNT.uid, 'uid')
              t.equal(Object.keys(account).length, 1, 'Only one field (uid) was returned, nothing else')
            })
            .then(function() {
              t.pass('Retrieving account using email')
              var emailBuffer = Buffer(ACCOUNT.email)
              return db.emailRecord(emailBuffer)
            })
            .then(function(account) {
              t.deepEqual(account.uid, ACCOUNT.uid, 'uid')
              t.equal(account.email, ACCOUNT.email, 'email')
              t.deepEqual(account.emailCode, ACCOUNT.emailCode, 'emailCode')
              t.equal(!!account.emailVerified, ACCOUNT.emailVerified, 'emailVerified')
              t.deepEqual(account.kA, ACCOUNT.kA, 'kA')
              t.deepEqual(account.wrapWrapKb, ACCOUNT.wrapWrapKb, 'wrapWrapKb')
              t.notOk(account.verifyHash, 'verifyHash field should be absent')
              t.deepEqual(account.authSalt, ACCOUNT.authSalt, 'authSalt')
              t.equal(account.verifierVersion, ACCOUNT.verifierVersion, 'verifierVersion')
              t.equal(account.verifierSetAt, ACCOUNT.verifierSetAt, 'verifierSetAt')
              // locale not returned with .emailRecord() (unlike .account() when it is)
            })
            // and we piggyback some duplicate query error handling here...
            .then(function() {
              return db.createAccount(ACCOUNT.uid, ACCOUNT)
            })
            .then(
              function() {
                t.fail('this should have resulted in a duplicate account error')
              },
              function(err) {
                t.ok(err, 'trying to create the same account produces an error')
                t.equal(err.code, 409, 'error code')
                t.equal(err.errno, 101, 'error errno')
                t.equal(err.message, 'Record already exists', 'message')
                t.equal(err.error, 'Conflict', 'error')
              }
            )
          }
        )

        test(
          'session token handling',
          function (t) {
            t.plan(56)
            return db.sessions(ACCOUNT.uid)
              .then(function(sessions) {
                t.ok(Array.isArray(sessions), 'sessions is an array')
                t.equal(sessions.length, 0, 'sessions is empty')
                return db.createSessionToken(SESSION_TOKEN_ID, SESSION_TOKEN)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on session token creation')
                return db.sessions(ACCOUNT.uid)
              })
              .then(function (sessions) {
                t.equal(sessions.length, 1, 'sessions contains one item')
                t.equal(Object.keys(sessions[0]).length, 9, 'session has nine properties')
                t.equal(sessions[0].tokenId.toString('hex'), SESSION_TOKEN_ID.toString('hex'), 'tokenId is correct')
                t.equal(sessions[0].uid.toString('hex'), ACCOUNT.uid.toString('hex'), 'uid is correct')
                t.equal(sessions[0].createdAt, SESSION_TOKEN.createdAt, 'createdAt is correct')
                t.equal(sessions[0].uaBrowser, SESSION_TOKEN.uaBrowser, 'uaBrowser is correct')
                t.equal(sessions[0].uaBrowserVersion, SESSION_TOKEN.uaBrowserVersion, 'uaBrowserVersion is correct')
                t.equal(sessions[0].uaOS, SESSION_TOKEN.uaOS, 'uaOS is correct')
                t.equal(sessions[0].uaOSVersion, SESSION_TOKEN.uaOSVersion, 'uaOSVersion is correct')
                t.equal(sessions[0].uaDeviceType, SESSION_TOKEN.uaDeviceType, 'uaDeviceType is correct')
                t.equal(sessions[0].lastAccessTime, SESSION_TOKEN.createdAt, 'lastAccessTime is correct')
                return db.sessionToken(SESSION_TOKEN_ID)
              })
              .then(function(token) {
                // tokenId is not returned from db.sessionToken()
                t.deepEqual(token.tokenData, SESSION_TOKEN.data, 'token data matches')
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.equal(token.createdAt, SESSION_TOKEN.createdAt, 'createdAt is correct')
                t.equal(token.uaBrowser, SESSION_TOKEN.uaBrowser, 'uaBrowser is correct')
                t.equal(token.uaBrowserVersion, SESSION_TOKEN.uaBrowserVersion, 'uaBrowserVersion is correct')
                t.equal(token.uaOS, SESSION_TOKEN.uaOS, 'uaOS is correct')
                t.equal(token.uaOSVersion, SESSION_TOKEN.uaOSVersion, 'uaOSVersion is correct')
                t.equal(token.uaDeviceType, SESSION_TOKEN.uaDeviceType, 'uaDeviceType is correct')
                t.equal(token.lastAccessTime, SESSION_TOKEN.createdAt, 'lastAccessTime was set')
                t.equal(!!token.emailVerified, ACCOUNT.emailVerified, 'token emailVerified is same as account emailVerified')
                t.equal(token.email, ACCOUNT.email, 'token email same as account email')
                t.deepEqual(token.emailCode, ACCOUNT.emailCode, 'token emailCode same as account emailCode')
                t.equal(token.verifierSetAt, ACCOUNT.verifierSetAt, 'verifierSetAt is correct')
                t.equal(token.accountCreatedAt, ACCOUNT.createdAt, 'accountCreatedAt is correct')
              })
              .then(function() {
                return db.updateSessionToken(SESSION_TOKEN_ID, {
                  uaBrowser: 'foo',
                  uaBrowserVersion: '1',
                  uaOS: 'bar',
                  uaOSVersion: '2',
                  uaDeviceType: 'baz',
                  lastAccessTime: 42
                })
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on session token update')
                return db.sessions(ACCOUNT.uid)
              })
              .then(function (sessions) {
                t.equal(sessions.length, 1, 'sessions still contains one item')
                t.equal(sessions[0].tokenId.toString('hex'), SESSION_TOKEN_ID.toString('hex'), 'tokenId is correct')
                t.equal(sessions[0].uid.toString('hex'), ACCOUNT.uid.toString('hex'), 'uid is correct')
                t.equal(sessions[0].createdAt, SESSION_TOKEN.createdAt, 'createdAt is correct')
                t.equal(sessions[0].uaBrowser, 'foo', 'uaBrowser is correct')
                t.equal(sessions[0].uaBrowserVersion, '1', 'uaBrowserVersion is correct')
                t.equal(sessions[0].uaOS, 'bar', 'uaOS is correct')
                t.equal(sessions[0].uaOSVersion, '2', 'uaOSVersion is correct')
                t.equal(sessions[0].uaDeviceType, 'baz', 'uaDeviceType is correct')
                t.equal(sessions[0].lastAccessTime, 42, 'lastAccessTime is correct')
                return db.sessionToken(SESSION_TOKEN_ID)
              })
              .then(function(token) {
                t.deepEqual(token.tokenData, SESSION_TOKEN.data, 'token data matches')
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.equal(token.createdAt, SESSION_TOKEN.createdAt, 'createdAt is correct')
                t.equal(token.uaBrowser, 'foo', 'uaBrowser is correct')
                t.equal(token.uaBrowserVersion, '1', 'uaBrowserVersion is correct')
                t.equal(token.uaOS, 'bar', 'uaOS is correct')
                t.equal(token.uaOSVersion, '2', 'uaOSVersion is correct')
                t.equal(token.uaDeviceType, 'baz', 'uaDeviceType is correct')
                t.equal(token.lastAccessTime, 42, 'lastAccessTime is correct')
                t.equal(!!token.emailVerified, ACCOUNT.emailVerified, 'token emailVerified is same as account emailVerified')
                t.equal(token.email, ACCOUNT.email, 'token email same as account email')
                t.deepEqual(token.emailCode, ACCOUNT.emailCode, 'token emailCode same as account emailCode')
                t.equal(token.verifierSetAt, ACCOUNT.verifierSetAt, 'verifierSetAt is correct')
                t.equal(token.accountCreatedAt, ACCOUNT.createdAt, 'accountCreatedAt is correct')
              })
              .then(function() {
                return db.deleteSessionToken(SESSION_TOKEN_ID)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on forgot key fetch token deletion')
                return db.sessions(ACCOUNT.uid)
              })
              .then(function (sessions) {
                t.equal(sessions.length, 0, 'sessions is empty')
                return db.sessionToken(SESSION_TOKEN_ID)
              })
              .then(function(token) {
                t.fail('Session Token should no longer exist')
              }, function(err) {
                t.pass('Session Token deleted successfully')
              })
          }
        )

        test(
          'key fetch token handling',
          function (t) {
            t.plan(8)
            return db.createKeyFetchToken(KEY_FETCH_TOKEN_ID, KEY_FETCH_TOKEN)
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on key fetch token creation')
                return db.keyFetchToken(KEY_FETCH_TOKEN_ID)
              })
              .then(function(token) {
                // tokenId is not returned
                t.deepEqual(token.authKey, KEY_FETCH_TOKEN.authKey, 'authKey matches')
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.equal(token.createdAt, KEY_FETCH_TOKEN.createdAt, 'createdAt is ok')
                t.equal(!!token.emailVerified, ACCOUNT.emailVerified, 'emailVerified is correct')
                // email is not returned
                // emailCode is not returned
                t.equal(token.verifierSetAt, ACCOUNT.verifierSetAt, 'verifierSetAt is correct')
              })
              .then(function() {
                return db.deleteKeyFetchToken(KEY_FETCH_TOKEN_ID)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on forgot key fetch token deletion')
                return db.keyFetchToken(KEY_FETCH_TOKEN_ID)
              })
              .then(function(token) {
                t.fail('Key Fetch Token should no longer exist')
              }, function(err) {
                t.pass('Key Fetch Token deleted successfully')
              })
          }
        )

        test(
          'forgot password token handling',
          function (t) {
            t.plan(25)

            var token
            var THROWAWAY_PASSWORD_FORGOT_TOKEN_ID = hex32()
            var THROWAWAY_PASSWORD_FORGOT_TOKEN = {
              data : hex32(),
              uid : ACCOUNT.uid, // same account uid
              passCode : hex16(),
              tries : 1,
              createdAt: Date.now()
            }

            return db.createPasswordForgotToken(PASSWORD_FORGOT_TOKEN_ID, PASSWORD_FORGOT_TOKEN)
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on forgot password token creation')
                return db.passwordForgotToken(PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(newToken) {
                token = newToken
                // tokenId is not returned
                t.deepEqual(token.tokenData, PASSWORD_FORGOT_TOKEN.data, 'token data matches')
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.equal(token.createdAt, PASSWORD_FORGOT_TOKEN.createdAt, 'createdAt same')
                t.deepEqual(token.passCode, PASSWORD_FORGOT_TOKEN.passCode, 'token passCode same')
                t.equal(token.tries, PASSWORD_FORGOT_TOKEN.tries, 'Tries is correct')
                t.equal(token.email, ACCOUNT.email, 'token email same as account email')
                t.equal(token.verifierSetAt, ACCOUNT.verifierSetAt, 'verifierSetAt is set correctly')
              })
              .then(function() {
                return db.passwordForgotToken(PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(newToken) {
                token = newToken
                // tokenId is not returned
                t.deepEqual(token.tokenData, PASSWORD_FORGOT_TOKEN.data, 'token data matches')
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.equal(token.createdAt, PASSWORD_FORGOT_TOKEN.createdAt, 'createdAt is correct')
                t.deepEqual(token.passCode, PASSWORD_FORGOT_TOKEN.passCode, 'token passCode same')
                t.equal(token.tries, PASSWORD_FORGOT_TOKEN.tries, 'Tries is correct')
                t.equal(token.email, ACCOUNT.email, 'token email same as account email')
                t.equal(token.verifierSetAt, ACCOUNT.verifierSetAt, 'verifierSetAt is correct')
              })
              .then(function() {
                // just update the tries
                token.tries = 9
                return db.updatePasswordForgotToken(PASSWORD_FORGOT_TOKEN_ID, token)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'The returned object from the token update is empty')
                // re-fetch the updated token
                return db.passwordForgotToken(PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(newToken) {
                t.deepEqual(newToken.uid, ACCOUNT.uid, 'token belongs to this account')
                t.equal(newToken.tries, 9, 'token now has had 9 tries')
                return db.deletePasswordForgotToken(PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on forgot password token deletion')
                return db.passwordForgotToken(PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(newToken /* unused */) {
                t.fail('Password Forgot Token should no longer exist')
              }, function(err) {
                t.pass('Password Forgot Token deleted successfully')
              })
              .then(function() {
                // insert a throwaway token
                return db.createPasswordForgotToken(THROWAWAY_PASSWORD_FORGOT_TOKEN_ID, THROWAWAY_PASSWORD_FORGOT_TOKEN)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on forgot password token creation')
                // and we should be able to retrieve it as usual
                return db.passwordForgotToken(THROWAWAY_PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(token) {
                // just check that the tokenData is what we expect (complete tests are above)
                t.deepEqual(token.tokenData, THROWAWAY_PASSWORD_FORGOT_TOKEN.data, 'token data matches')
                // now, let's insert a different passwordForgotToken with the same uid
                return db.createPasswordForgotToken(PASSWORD_FORGOT_TOKEN_ID, PASSWORD_FORGOT_TOKEN)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on forgot password token creation (when overwriting another)')
                // if we retrieve the throwaway one, we should fail
                return db.passwordForgotToken(THROWAWAY_PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(newToken /* unused */) {
                t.fail('Throwaway Password Forgot Token should no longer exist')
              }, function(err) {
                t.pass('Throwaway Password Forgot Token deleted successfully')
                // but the new one is still there
                return db.passwordForgotToken(PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(token) {
                // just check that the tokenData is what we expect (complete tests are above)
                t.deepEqual(token.tokenData, PASSWORD_FORGOT_TOKEN.data, 'token data matches')
              }, function(err) {
                t.fail('We should have been able to retrieve the new password forgot token')
              })
          }
        )

        test(
          'change password token handling',
          function (t) {
            t.plan(13)

            var THROWAWAY_PASSWORD_CHANGE_TOKEN_ID = hex32()
            var THROWAWAY_PASSWORD_CHANGE_TOKEN = {
              data : hex32(),
              uid : ACCOUNT.uid, // same account uid
              createdAt: Date.now()
            }

            return db.createPasswordChangeToken(PASSWORD_CHANGE_TOKEN_ID, PASSWORD_CHANGE_TOKEN)
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on change password token creation')
                return db.passwordChangeToken(PASSWORD_CHANGE_TOKEN_ID)
              })
              .then(function(token) {
                // tokenId is not returned
                t.deepEqual(token.tokenData, PASSWORD_CHANGE_TOKEN.data, 'token data matches')
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.equal(token.createdAt, PASSWORD_CHANGE_TOKEN.createdAt, 'createdAt is correct')
                t.equal(token.verifierSetAt, ACCOUNT.verifierSetAt, 'verifierSetAt is set correctly')
                t.equal(token.email, ACCOUNT.email, 'email is set correctly')
              })
              .then(function() {
                return db.deletePasswordChangeToken(PASSWORD_CHANGE_TOKEN_ID)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on forgot password change deletion')
                return db.passwordChangeToken(PASSWORD_CHANGE_TOKEN_ID)
              })
              .then(function(token) {
                t.fail('Password Change Token should no longer exist')
              }, function(err) {
                t.pass('Password Change Token deleted successfully')
              })
              .then(function() {
                // insert a throwaway token
                return db.createPasswordChangeToken(THROWAWAY_PASSWORD_CHANGE_TOKEN_ID, THROWAWAY_PASSWORD_CHANGE_TOKEN)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on change password token creation')
                // and we should be able to retrieve it as usual
                return db.passwordChangeToken(THROWAWAY_PASSWORD_CHANGE_TOKEN_ID)
              })
              .then(function(token) {
                // just check that the tokenData is what we expect (complete tests are above)
                t.deepEqual(token.tokenData, THROWAWAY_PASSWORD_CHANGE_TOKEN.data, 'token data matches')
                // now, let's insert a different passwordChangeToken with the same uid
                return db.createPasswordChangeToken(PASSWORD_CHANGE_TOKEN_ID, PASSWORD_CHANGE_TOKEN)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on change password token creation (when overwriting another)')
                // if we retrieve the throwaway one, we should fail
                return db.passwordChangeToken(THROWAWAY_PASSWORD_CHANGE_TOKEN_ID)
              })
              .then(function(newToken /* unused */) {
                t.fail('Throwaway Password Change Token should no longer exist')
              }, function(err) {
                t.pass('Throwaway Password Change Token deleted successfully')
                // but the new one is still there
                return db.passwordChangeToken(PASSWORD_CHANGE_TOKEN_ID)
              })
              .then(function(token) {
                // just check that the tokenData is what we expect (complete tests are above)
                t.deepEqual(token.tokenData, PASSWORD_CHANGE_TOKEN.data, 'token data matches')
              }, function(err) {
                t.fail('We should have been able to retrieve the new password change token')
              })
          }
        )

        test(
          'email verification and locale change',
          function (t) {
            t.plan(6)

            var emailBuffer = Buffer(ACCOUNT.email)
            return db.emailRecord(emailBuffer)
            .then(function(emailRecord) {
              return db.verifyEmail(emailRecord.uid)
            })
            .then(function(result) {
              t.deepEqual(result, {}, 'Returned an empty object email verification')
              return db.account(ACCOUNT.uid)
            })
            .then(function(account) {
              t.ok(account.emailVerified, 'account should now be emailVerified (truthy)')
              t.equal(account.emailVerified, 1, 'account should now be emailVerified (1)')

              account.locale = 'en_NZ'
              return db.updateLocale(ACCOUNT.uid, account)
            })
            .then(function(result) {
              t.deepEqual(result, {}, 'Returned an empty object for updateLocale')
              return db.account(ACCOUNT.uid)
            })
            .then(function(account) {
              t.equal(account.locale, 'en_NZ', 'account should now have new locale')

              // test verifyEmail for a non-existant account
              return db.verifyEmail(newUuid())
            })
            .then(function(res) {
              t.deepEqual(res, {}, 'No matter what happens, we get an empty object back')
            }, function(err) {
              t.fail('We should not have failed this .verifyEmail() request')
            })
          }
        )

        test(
          'locked accounts',
          function (t) {
            t.plan(7)

            var lockedAt = Date.now()
            var unlockCode = hex16()
            var uid = ACCOUNT.uid
            var email = Buffer(ACCOUNT.email)

              // set lockedAt
            return db.lockAccount(uid, { lockedAt: lockedAt, unlockCode: unlockCode })
              .then(null, function(err) {
                t.fail('We should not have failed this .lockAccount() request')
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object for lockAccount')
                return db.account(uid)
              })
              .then(function(account) {
                t.equal(account.lockedAt, lockedAt, 'account should now be locked')
                return db.emailRecord(email)
              })
              .then(function(emailRecord) {
                t.equal(emailRecord.lockedAt, lockedAt, 'emailRecord should show the account as locked')

                return db.unlockCode(uid)
              })
              .then(function (_unlockCode) {
                t.deepEqual(_unlockCode.unlockCode, unlockCode, 'unlockCode should be set')

                // try to unlock the account
                return db.unlockAccount(uid)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object for unlockAccount')
                // get this account back out
                return db.account(uid)
              }, function(err) {
                t.fail('We should not have failed this .unlockAccount() request')
              })
              .then(function(account) {
                t.equal(account.lockedAt, null, 'account should now be unlocked')
                // now check it's been saved
                return db.emailRecord(email)
              })
              .then(function(emailRecord) {
                t.equal(emailRecord.lockedAt, null, 'emailRecord should now show the account as unlocked')
              })
          }
        )

        test(
          'account reset token handling',
          function (t) {
            t.plan(14)

            // create a second accountResetToken
            var accountResetTokenId = hex32()
            var accountResetToken = {
              data : hex32(),
              uid : ACCOUNT.uid,
              createdAt: Date.now()
            }

            return db.createAccountResetToken(ACCOUNT_RESET_TOKEN_ID, ACCOUNT_RESET_TOKEN)
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on account reset token creation')
                return db.accountResetToken(ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(token) {
                // tokenId is not returned
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.deepEqual(token.tokenData, ACCOUNT_RESET_TOKEN.data, 'token data matches')
                t.equal(token.createdAt, ACCOUNT_RESET_TOKEN.createdAt, 'createdAt is correct')
                t.ok(token.verifierSetAt, 'verifierSetAt is set to a truthy value')
              })
              .then(function() {
                return db.deleteAccountResetToken(ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on account reset deletion')
                return db.accountResetToken(ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(token) {
                t.fail('Account Reset Token should no longer exist')
              }, function(err) {
                t.pass('Account Reset Token deleted successfully')
              })
              .then(function() {
                // Now add back in the original token
                return db.createAccountResetToken(ACCOUNT_RESET_TOKEN_ID, ACCOUNT_RESET_TOKEN)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on account reset token creation (for the 2nd time)')
                // get this back out
                return db.accountResetToken(ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(token) {
                // tokenId is not returned
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.deepEqual(token.tokenData, ACCOUNT_RESET_TOKEN.data, 'token data matches')
                // replace this token with a new one
                return db.createAccountResetToken(accountResetTokenId, accountResetToken)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on second account reset token creation')
                // now retrieve this one
                return db.accountResetToken(accountResetTokenId)
              })
              .then(function(token) {
                // check a couple of fields
                t.deepEqual(token.uid, ACCOUNT.uid, 'token belongs to this account')
                t.deepEqual(token.tokenData, accountResetToken.data, 'token data matches')
                // now check that the original token no longer exists
                return db.accountResetToken(ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(token) {
                t.fail('Original Account Reset Token should no longer exist')
              }, function(err) {
                t.pass('Original Account Reset Token is no longer there')
              })
          }
        )

        test(
          'db.forgotPasswordVerified',
          function (t) {
            t.plan(19)
            // for this test, we are creating a new account with a different email address
            // so that we can check that emailVerified turns from false to true (since
            // we already set it to true earlier)
            var account = createAccount()
            var PASSWORD_FORGOT_TOKEN_ID = hex32()
            var PASSWORD_FORGOT_TOKEN = {
              data : hex32(),
              uid : account.uid,
              passCode : hex16(),
              tries : 1,
              createdAt: now + 1
            }
            var ACCOUNT_RESET_TOKEN_ID = hex32()
            var ACCOUNT_RESET_TOKEN = {
              tokenId : ACCOUNT_RESET_TOKEN_ID,
              data : hex32(),
              uid : account.uid,
              createdAt: now + 2
            }
            var THROWAWAY_ACCOUNT_RESET_TOKEN_ID = hex32()
            var THROWAWAY_ACCOUNT_RESET_TOKEN = {
              tokenId : ACCOUNT_RESET_TOKEN_ID,
              data : hex32(),
              uid : account.uid,
              createdAt: now + 3
            }
            var ACCOUNT_UNLOCK_CODE = hex16()

            return db.createAccount(account.uid, account)
              .then(function() {
                // let's add a throwaway accountResetToken, which should be overwritten when
                // we call passwordForgotToken() later.
                return db.createAccountResetToken(THROWAWAY_ACCOUNT_RESET_TOKEN_ID, THROWAWAY_ACCOUNT_RESET_TOKEN)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on account reset token creation (the throwaway one)')
                // let's get it back out to make sure it is there
                return db.accountResetToken(THROWAWAY_ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(token) {
                // check a couple of fields
                t.deepEqual(token.uid, account.uid, 'token belongs to this account')
                t.deepEqual(token.tokenData, THROWAWAY_ACCOUNT_RESET_TOKEN.data, 'token data matches')
                // get this account out using emailRecord
                var emailBuffer = Buffer(account.email)
                return db.emailRecord(emailBuffer)
              })
              .then(function(result) {
                t.pass('.emailRecord() did not error')
                return db.createPasswordForgotToken(PASSWORD_FORGOT_TOKEN_ID, PASSWORD_FORGOT_TOKEN)
              })
              .then(function(passwordForgotToken) {
                t.pass('.createPasswordForgotToken() did not error')
                // let's also lock the account here so we can check it is unlocked after the createPasswordForgotToken()
                return db.lockAccount(account.uid, { lockedAt: Date.now(), unlockCode: ACCOUNT_UNLOCK_CODE })
              })
              .then(function(passwordForgotToken) {
                t.pass('.lockAccount() did not error')
                return db.forgotPasswordVerified(PASSWORD_FORGOT_TOKEN_ID, ACCOUNT_RESET_TOKEN)
              })
              .then(function() {
                t.pass('.forgotPasswordVerified() did not error')
                // now check that the forgotPasswordVerified also reset the lockedAt
                return db.emailRecord(Buffer(account.email))
              })
              .then(function(account) {
                t.equal(account.lockedAt, null, 'account should now be unlocked')
                return db.forgotPasswordVerified(PASSWORD_FORGOT_TOKEN_ID, ACCOUNT_RESET_TOKEN)
              })
              .then(function() {
                t.pass('.forgotPasswordVerified() did not error')
                // let's try and get the throwaway accountResetToken (shouldn't exist any longer)
                return db.accountResetToken(THROWAWAY_ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(token) {
                t.fail('Throwaway Account Reset Token should no longer exist')
              }, function(err) {
                t.pass('Throwaway Account Reset Token deleted during forgotPasswordVerified')
                // retrieve passwordForgotToken (shouldn't exist now)
                return db.passwordForgotToken(PASSWORD_FORGOT_TOKEN_ID)
              })
              .then(function(token) {
                t.fail('Password Forgot Token should no longer exist')
              }, function(err) {
                t.pass('Password Forgot Token deleted successfully')
              })
              .then(function() {
                return db.accountResetToken(ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(accountResetToken) {
                t.pass('.accountResetToken() did not error')
                // tokenId is not returned
                t.deepEqual(accountResetToken.uid, account.uid, 'token belongs to this account')
                t.deepEqual(accountResetToken.tokenData, ACCOUNT_RESET_TOKEN.data, 'token data matches')
                t.equal(accountResetToken.verifierSetAt, account.verifierSetAt, 'verifierSetAt is set correctly')
              })
              .then(function() {
                return db.account(account.uid)
              })
              .then(function(account) {
                t.ok(account.emailVerified, 'account should now be emailVerified (truthy)')
                t.equal(account.emailVerified, 1, 'account should now be emailVerified (1)')
              })
              .then(function() {
                return db.deleteAccountResetToken(ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object on account reset deletion')
                return db.accountResetToken(ACCOUNT_RESET_TOKEN_ID)
              })
              .then(function(token) {
                t.fail('Account Reset Token should no longer exist')
              }, function(err) {
                t.pass('Account Reset Token deleted successfully')
              })
          }
        )

        test(
          'db.accountDevices',
          function (t) {
            t.plan(51)
            var deviceId = newUuid()
            var sessionTokenId = hex32()
            var createdAt = Date.now()
            var deviceInfo = {
              name: 'test device',
              type: 'mobile',
              callbackURL: 'https://foo/bar',
              callbackPublicKey: hex32()
            }
            var newDeviceId = newUuid()
            var newSessionTokenId = hex32()
            return db.updateDevice(ACCOUNT.uid, deviceId, deviceInfo)
              .then(function () {
                t.fail('updating a non-existent device should have failed')
              }, function (err) {
                t.pass('updating a non-existent device failed')
                t.equal(err.code, 404, 'err.code')
                t.equal(err.errno, 116, 'err.errno')
              })
              .then(function () {
                return db.createSessionToken(sessionTokenId, SESSION_TOKEN)
              })
              .then(function (sessionToken) {
                return db.createDevice(ACCOUNT.uid, deviceId, {
                  sessionTokenId: sessionTokenId,
                  createdAt: createdAt
                })
                .catch(function () {
                  t.fail('adding a new device should not have failed')
                })
              })
              .then(function (result) {
                t.deepEqual(result, {}, 'returned empty object')
                return db.createDevice(ACCOUNT.uid, deviceId, {
                  sessionTokenId: newSessionTokenId,
                  createdAt: Date.now()
                })
                .then(function () {
                  t.fail('adding a duplicate device should have failed')
                }, function (err) {
                  t.pass('adding a duplicate device failed')
                  t.equal(err.code, 409, 'err.code')
                  t.equal(err.errno, 101, 'err.errno')
                })
              })
              .then(function () {
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 1, 'devices length 1')
                return devices[0]
              })
              .then(function (device) {
                t.deepEqual(device.sessionTokenId, sessionTokenId, 'sessionTokenId')
                t.equal(device.name, null, 'name')
                t.deepEqual(device.id, deviceId, 'id')
                t.equal(device.createdAt, createdAt, 'createdAt')
                t.equal(device.type, null, 'type')
                t.equal(device.callbackURL, null, 'callbackURL')
                t.deepEqual(device.callbackPublicKey, null, 'callbackPublicKey')
                t.ok(device.lastAccessTime > 0, 'has a lastAccessTime')
              })
              .then(function () {
                return db.updateDevice(ACCOUNT.uid, deviceId, deviceInfo)
                  .catch(function () {
                    t.fail('updating an existing device should not have failed')
                  })
              })
              .then(function (result) {
                t.deepEqual(result, {}, 'returned empty object')
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 1, 'devices length still 1')
                return devices[0]
              })
              .then(function (device) {
                t.deepEqual(device.sessionTokenId, sessionTokenId, 'sessionTokenId')
                t.equal(device.name, deviceInfo.name, 'name')
                t.deepEqual(device.id, deviceId, 'id')
                t.equal(device.createdAt, createdAt, 'createdAt')
                t.equal(device.type, deviceInfo.type, 'type')
                t.equal(device.callbackURL, deviceInfo.callbackURL, 'callbackURL')
                t.deepEqual(device.callbackPublicKey, deviceInfo.callbackPublicKey, 'callbackPublicKey')
                t.ok(device.lastAccessTime > 0, 'has a lastAccessTime')
                return db.createSessionToken(newSessionTokenId, SESSION_TOKEN)
              })
              .then(function () {
                return db.updateDevice(ACCOUNT.uid, deviceId, {
                  sessionTokenId: newSessionTokenId,
                  name: 'updated name',
                  type: null
                })
                .catch(function () {
                  t.fail('updating an existing device should not have failed')
                })
              })
              .then(function () {
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 1, 'devices length still 1')
                return devices[0]
              })
              .then(function (device) {
                t.deepEqual(device.sessionTokenId, newSessionTokenId, 'sessionTokenId updated')
                t.equal(device.name, 'updated name', 'name updated')
                t.equal(device.type, deviceInfo.type, 'type unchanged')
                t.equal(device.callbackURL, deviceInfo.callbackURL, 'callbackURL unchanged')
                t.deepEqual(device.callbackPublicKey, deviceInfo.callbackPublicKey, 'callbackPublicKey unchanged')
                return db.updateDevice(ACCOUNT.uid, deviceId, {
                  type: 'desktop',
                  callbackURL: '',
                  callbackPublicKey: ''
                })
                .catch(function () {
                  t.fail('updating an existing device should not have failed')
                })
              })
              .then(function (result) {
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 1, 'devices length still 1')
                return devices[0]
              })
              .then(function (device) {
                t.deepEqual(device.sessionTokenId, newSessionTokenId, 'sessionTokenId updated')
                t.equal(device.name, 'updated name', 'name unchanged')
                t.equal(device.type, 'desktop', 'type updated')
                t.equal(device.callbackURL, '', 'callbackURL updated')
                t.deepEqual(device.callbackPublicKey, zeroBuffer32, 'callbackPublicKey updated')
                return db.createDevice(ACCOUNT.uid, newUuid(), {
                  sessionTokenId: newSessionTokenId,
                  name: 'second device',
                  createdAt: Date.now(),
                  type: 'desktop',
                  callbackURL: 'https://foo/bar',
                  callbackPublicKey: hex32()
                })
                .then(function () {
                  t.fail('adding a second device should have failed when the session token is already registered')
                }, function (err) {
                  t.pass('adding a second device failed when the session token is already registered')
                  t.equal(err.code, 409, 'err.code')
                  t.equal(err.errno, 101, 'err.errno')
                })
              })
              .then(function () {
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 1, 'devices length still 1')
                return db.createDevice(ACCOUNT.uid, newDeviceId, {
                  sessionTokenId: sessionTokenId,
                  name: 'second device',
                  createdAt: Date.now(),
                  type: 'desktop',
                  callbackURL: 'https://foo/bar',
                  callbackPublicKey: hex32()
                })
                .then(function () {
                  t.pass('adding a second device did not fail when the session token is not registered')
                }, function (err) {
                  t.fail('adding a second device should not have failed when the session token is not registered')
                })
              })
              .then(function () {
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 2, 'devices length 2')
                return db.deleteDevice(ACCOUNT.uid, deviceId)
              })
              .then(function (result) {
                t.deepEqual(result, {}, 'returned empty object')
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 1, 'devices length 1')
                return db.deleteDevice(ACCOUNT.uid, deviceId)
                  .then(function () {
                    t.fail('deleting a non-existent device should have failed')
                  }, function (err) {
                    t.pass('deleting a non-existent device failed')
                    t.equal(err.code, 404, 'err.code')
                    t.equal(err.errno, 116, 'err.errno')
                  })
              })
              .then(function () {
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 1, 'devices length 1')
                return db.deleteDevice(ACCOUNT.uid, newDeviceId)
              })
              .then(function () {
                return db.accountDevices(ACCOUNT.uid)
              })
              .then(function (devices) {
                t.equal(devices.length, 0, 'devices length 0')
              })
          }
        )

        test(
          'db.resetAccount',
          function (t) {
            t.plan(9)
            var uid = ACCOUNT.uid
            var lockedAt = Date.now()
            var unlockCode = hex16()

            return db.createSessionToken(SESSION_TOKEN_ID, SESSION_TOKEN)
              .then(function(sessionToken) {
                t.pass('.createSessionToken() did not error')
                return db.createAccountResetToken(ACCOUNT_RESET_TOKEN_ID, ACCOUNT_RESET_TOKEN)
              })
              .then(function() {
                t.pass('.createAccountResetToken() did not error')
                // lock the account to ensure the unlockCode is deleted
                return db.lockAccount(uid, { lockedAt: lockedAt, unlockCode: unlockCode })
              })
              .then(function() {
                t.pass('.lockAccount() did not error')
                return db.unlockCode(uid)
              })
              .then(function(unlockCode) {
                t.ok(unlockCode.unlockCode, 'unlockCode is correctly returned')
                return db.resetAccount(uid, ACCOUNT)
              })
              .then(function(sessionToken) {
                t.pass('.resetAccount() did not error')
                return db.accountDevices(uid)
              })
              .then(function(devices) {
                t.pass('.accountDevices() did not error')
                t.equal(devices.length, 0, 'The devices length should be zero')
              })
              .then(function() {
                // account should STILL exist for this email address
                var emailBuffer = Buffer(ACCOUNT.email)
                return db.accountExists(emailBuffer)
              })
              .then(function(exists) {
                t.ok(exists, 'account still exists ok')
                return db.unlockCode(uid)
              }, function(err) {
                t.fail('the account for this email address should still exist')
              })
              .then(function(unlockCode) {
                t.fail('an unlockCode should no longer exist for this uid')
              }, function(err) {
                t.pass('unlockCode is deleted for this uid')
              })
          }
        )

        test(
          'account deletion',
          function (t) {
            t.plan(3)
            var uid = ACCOUNT.uid
            var lockedAt = Date.now()
            var unlockCode = hex16()
            // lock the account to ensure the unlockCode is deleted
            return db.lockAccount(uid, { lockedAt: lockedAt, unlockCode: unlockCode })
              .then(function() {
                return db.deleteAccount(uid)
              })
              .then(function() {
                // account should no longer exist for this email address
                var emailBuffer = Buffer(ACCOUNT.email)
                return db.accountExists(emailBuffer)
              })
              .then(function(exists) {
                t.fail('account should no longer exist for this email address')
              }, function(err) {
                t.pass('account no longer exists for this email address')
                return db.unlockCode(uid)
              })
              .then(function(unlockCode) {
                t.fail('an unlockCode should no longer exist for this uid')
              }, function(err) {
                t.pass('unlockCode is deleted for this uid')

                // try to unlock the account
                return db.unlockAccount(uid)
              })
              .then(function(result) {
                t.deepEqual(result, {}, 'Returned an empty object for unlockAccount')
              }, function(err) {
                t.fail('We should not have failed this .unlockAccount() request')
              })
          }
        )

        test(
          'openid create and get',
          function (t) {
            t.plan(11)
            var account = createAccount()
            account.openId = 'https://openid.example.com/foo' + hex16()
            return db.createAccount(account.uid, account)
              .then(
                function () {
                  return db.openIdRecord(account.openId)
                }
              )
              .then(
                function (record) {
                  t.deepEqual(record.uid, account.uid, 'uid')
                  t.equal(record.email, account.email, 'email')
                  t.deepEqual(record.emailCode, account.emailCode, 'emailCode')
                  t.equal(!!record.emailVerified, account.emailVerified, 'emailVerified')
                  t.deepEqual(record.kA, account.kA, 'kA')
                  t.deepEqual(record.wrapWrapKb, account.wrapWrapKb, 'wrapWrapKb')
                  t.notOk(record.verifyHash, 'verifyHash field should be absent')
                  t.deepEqual(record.authSalt, account.authSalt, 'authSalt')
                  t.equal(record.verifierVersion, account.verifierVersion, 'verifierVersion')
                  t.equal(record.verifierSetAt, account.verifierSetAt, 'verifierSetAt')
                  t.equal(record.openId, account.openId)
                }
              )
          }
        )

        test(
          'teardown',
          function (t) {
            return db.close()
          }
        )

      }
    )
}
