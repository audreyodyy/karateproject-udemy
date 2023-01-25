function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://api.realworld.io/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'userone@mail.com'
    config.userPassword = 'useronepass'
  } else if (env == 'qa') {
    config.userEmail = 'useroneqa@mail.com'
    config.userPassword = 'useroneqapass'
  }

  var accessToken = karate.callSingle('classpath:helpers/createToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})
  return config;
}