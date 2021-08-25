const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Tokens', () => {
    let Token, address1, address2, addresses, hardhatToken, owner, initialBalance;

    // declare blocks of code to run everytime before each tests
    // logically, i want to get the contract instance, get the sender's address and also deploy contract here
    beforeEach(async () => {
        [owner, address1, address2, ...addresses] = await ethers.getSigners();
        Token = await ethers.getContractFactory('Token');
        hardhatToken = await Token.deploy();
        initialBalance = await hardhatToken.totalSupply();
    })

    describe('Token Initialization', () => {
        it('Should initialize the owner', async () => {
            expect(await hardhatToken.owner()).to.equal(owner.address);
        });

        it('Should assign the Toke to owner', async () => {
            const balance = await hardhatToken.getBalance(owner.address);
            expect(initialBalance).to.equal(balance);
        })
    })

    describe('Token Transfers', async () => {
        it('Should transfer tokens between accounts', async () => {
            // should transfer token from owner to address1
            await hardhatToken.sendToken(address1.address, 50);
            const addr1Balance = await hardhatToken.getBalance(address1.address);

            // address1 should receive a balance of 50
            expect(addr1Balance).to.equal(50);
            // verify fom balances that transaction actually happened
            expect(await hardhatToken.getBalance(owner.address)).to.equal(initialBalance - 50);

            // should send tokens from address1 to address2
            const address1Balance = await hardhatToken.getBalance(address1.address);
            await hardhatToken.connect(address1).sendToken(address2.address, 10);
            const address2Balance = await hardhatToken.getBalance(address2.address);
            expect(address2Balance).to.equal(10);

            // verify fom balances that transaction actually happened
            expect(await hardhatToken.getBalance(address1.address)).to.equal(address1Balance - 10);
        })

        it('Should fail if tokens are not enough to send', async () => {
            // check if address1 can send 10 tokens 
            // weird that this fails if i await the sendToken call only
            await expect(hardhatToken.connect(address1).sendToken(owner.address, 10)).to.be.revertedWith("Not enough Tokens");

            expect(await hardhatToken.getBalance(owner.address)).to.equal(initialBalance);
        })
    })
})