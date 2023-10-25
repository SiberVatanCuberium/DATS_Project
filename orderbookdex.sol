// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//DATS Project Task-2 Baturalp Güvenç

contract DEX {
    address public owner;
    uint256 public feePercentage; // Alım satım işlemlerinden alınan ücret yüzdesi burada girilmiştir.
    mapping(address => mapping(address => uint256)) public balances; // Kullanıcı bakiyelerini saklayacak olan mapping

    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdraw(address indexed user, address indexed token, uint256 amount);
    event Trade(
        address indexed user,
        address indexed tokenGive,
        uint256 amountGive,
        address indexed tokenGet,
        uint256 amountGet
    );

    constructor() {
        owner = msg.sender;
        feePercentage = 1; //  Alım satım işlemlerinden %1 ücret almak için.
    }

    // Kullanıcıların token çiftleri arasında takas yapabilmesini sağlayacak işlem
    function trade( //ticaret fonksiyonu:
        address tokenGive, // adrese token verme:
        uint256 amountGive, // verilmek istenen miktar inputu:
        address tokenGet, // adrese token alma:
        uint256 amountGet // alınmak istenen token miktarı:
    ) public {
        // Kullanıcının yeterli bakiyeye sahip olduğundan emin olmak için kontrol etme
        require(balances[msg.sender][tokenGive] >= amountGive, "Yetersiz tokenGive miktari..");
        require(balances[msg.sender][tokenGet] >= amountGet, "Yetersiz tokenGet miktari..");

        // Swap işlemi 
        balances[msg.sender][tokenGive] -= amountGive;
        balances[msg.sender][tokenGet] += amountGet;

        // Alım-satım işleminden ücretlendirme 
        uint256 fee = (amountGive * feePercentage) / 100;
        balances[owner][tokenGive] += fee;

        // Alım satım işlemi bildirimini tetikleme
        emit Trade(msg.sender, tokenGive, amountGive, tokenGet, amountGet); 
    }

    // Kullanıcıların hesabına token eklemek için kullanılacak işlem
    function deposit(address token, uint256 amount) public {
        // Kullanıcının token'ı hesabına eklemesini sağlama
        balances[msg.sender][token] += amount;

        // Deposit işlemi bildirimini tetikle
        emit Deposit(msg.sender, token, amount);
    }

    // Kullanıcıların hesabından token çekmek için kullanılacak işlem
    function withdraw(address token, uint256 amount) public {
        // Kullanıcının yeterli bakiyeye sahip olduğunu tekrar kontrol etme
        require(balances[msg.sender][token] >= amount, "Yetersiz Bakiye");

        // Token'ı kullanıcının hesabından çekme işlemi
        balances[msg.sender][token] -= amount;

        // Withdraw işlemi bildirimini tetikle
        emit Withdraw(msg.sender, token, amount);
    }
}

/* 
* "Withdraw işlemi," bir kullanıcının bir belirli varlık veya tokeni 
(örneğin, Ethereum veya başka bir kripto para birimi) hesabından çekmesi anlamına gelir. 
-
* Bu işlem, kullanıcının hesabında bulunan belirli bir varlık miktarını, 
genellikle kişisel cüzdanlarına veya başka bir hesaba aktarmasını içerir.
*/
