# PE Gitlab Vagrant Stack

The goal of the stack is to facilitate testing and understanding of how to use setup r10k with gitlab  

The stack automates installation of the webhook on the puppet-master with some puppet code in site.pp.

The final steps to setup the post receive hook are manual.  

1. Make sure your ssh key is setup for root on the puppet master and you've configured it for your gitlab user
 - <find a link>
2. Configure a post-receive hook on your control repo
 - <find another link>
3. You can confirm it all works by tailing the webhook logs while pushing a change to your control repo
 - `tail -f -n 0 /var/log/webhook/*.log`


## Other Notes

This is based on the puppet-debugging-kit.  

https://github.com/Sharpie/puppet-debugging-kit
