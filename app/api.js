
/// npm install --save teemojs /// 
/// npm install node-fetch@2 /// required to work with CommonJs and require ()

/// Developer API-key uninstalls every 24 hours --- https://developer.riotgames.com ///

const TeemoJS = require('teemojs');
const config = require('./config');
const fetch = require('node-fetch');

let api = TeemoJS(config.api_key);

const url = 'https://developer.riotgames.com//riot/account/v1/accounts/by-puuid/'
//async function getRequest(summoner) {}};

/// user = await getRequest('LotusFlowerWolf')
// console.log(user)



api.get('na1', 'summoner.getBySummonerName', "LotusFlowerWolf")
  .then(data => console.log(data.name + "'s summoner id is " + data.id + '.'))
  .then()

