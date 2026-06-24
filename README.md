# Azure Multi-Region Terraform Infrastructure (Hinglish Guide)

Is project ke andar ek multi-region, modular Azure infrastructure deploy kiya gaya hai. Neeche diye gaye steps me bataya gaya hai ki Terraform kis sequential order (dependency order) me Azure ke andar saare resources ko create karta hai.

---

## Logical Resource Creation Flow (Step-by-Step)

Terraform automatically resources ki dependency samajhta hai aur unhe neeche diye gaye sequence me deploy karta hai:

### Step 1: Resource Group (RG) Creation
* **Kya hota hai**: Sabse pehle Resource Groups (`rg-centralindia` aur `rg-canadacentral`) create hote hain.
* **Kyun zaroori hai**: Azure me baki ke saare resources inhi Resource Groups ke andar hi bante hain.

### Step 2: Random String Generation
* **Kya hota hai**: Ek random string generator trigger hota hai.
* **Kyun zaroori hai**: Kuch resources (jaise storage accounts) ko globally unique name chahiye hota hai, jo is random string se milta hai.

### Step 3: Virtual Network (VNet) Creation
* **Kya hota hai**: Dono regions me Virtual Networks (`vnet-centralindia` aur `vnet-canadacentral`) bante hain.
* **Kyun zaroori hai**: Ye aapke resources ke liye ek private network boundary define karte hain.

### Step 4: Subnets (Network Segmentation)
* **Kya hota hai**: VNets ke andar subnets create kiye jaate hain:
  - **VM Subnets**: `snet-vm-central` aur `snet-vm-canada` (VMs ke liye)
  - **Private Backend Subnet**: `snet-backend-central` (Private VMs ko isolate karne ke liye)
  - **Bastion Subnet**: `AzureBastionSubnet` (Bastion Host ke liye, iska name yahi hona zaroori hai)

### Step 5: VNet Peering
* **Kya hota hai**: Dono VNets ke beech me bi-directional peering establish hoti hai.
* **Kyun zaroori hai**: Isse Central India aur Canada Central ke resources aapas me privately communicate kar sakte hain.

### Step 6: Public IP Addresses
* **Kya hota hai**: Public-facing services ke liye Public IP resources create hote hain:
  - Bastion Host ke liye Public IP
  - Load Balancers ke liye Public IPs (`lb1` aur `lb2`)
  - NAT Gateways ke liye Public IPs (`nat1` aur `nat2`)

### Step 7: NAT Gateways (Outbound Internet)
* **Kya hota hai**: NAT Gateways create hote hain, unhe unke Public IPs se link kiya jata hai, aur phir unhe VM subnets aur Backend subnet se associate kiya jata hai.
* **Kyun zaroori hai**: Isse subnets ke andar chalne wale saare resources (jaise VMs) secure tarike se internet access kar sakte hain.

### Step 8: Network Security Groups (NSG)
* **Kya hota hai**: Network Security Groups bante hain.
* **Kyun zaroori hai**: Isme inbound rules set kiye jaate hain ports **22 (SSH)**, **80 (HTTP)**, aur **443 (HTTPS)** ko allow karne ke liye, taaki VMs safe rahein.

### Step 9: Network Interfaces (NIC)
* **Kya hota hai**: VMs ke liye Network Interfaces (NICs) subnets ke andar create hote hain aur unhe unke respective NSGs se link kiya jata hai.

### Step 10: Load Balancers (LB)
* **Kya hota hai**: Standard Load Balancers (`dev-lb-central` aur `dev-lb-canada`) bante hain. Health probes (port 80) aur load balancing rules (port 80) set kiye jaate hain, aur VMs ke NICs ko iske backend pool se link kiya jata hai.
* **Kyun zaroori hai**: Taaki external traffic load balancer ke through dono VMs me equal share ho sake.

### Step 11: Virtual Machines (VM)
* **Kya hota hai**: Jab network, subnets, NSGs, aur NICs sab ready ho jaate hain, tab Virtual Machines (`vm-central`, `vm-central2`, aur `vm-canada`) create hote hain aur unhe unke NICs ke sath attach kiya jata hai.

### Step 12: Bastion Host
* **Kya hota hai**: Sabse aakhir me, Bastion Host (`dev-bastion-central`) deploy hota hai `AzureBastionSubnet` ke andar.
* **Kyun zaroori hai**: Taaki aap internet se bina public IP ke, secure tarike se apne private VMs ko SSH/access kar sakein.

---

## Folder Structure

* `/Environment/dev`: Isme dev environment ke configurations hain (`main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`). **Saare Terraform commands isi directory ke andar se run karne hain.**
* `/Moduls`: Reusable aur custom child modules hain jo alag-alag Azure resources ko manage karte hain.

---

## Commands Kaise Run Karein (Step-by-Step)

1. **Dev directory me jayein**:
   ```bash
   cd Environment/dev
   ```
2. **Terraform initialize karein** (saare modules download aur register karne ke liye):
   ```bash
   terraform init
   ```
3. **Plan check karein** (dekhne ke liye ki kya-kya create hoga):
   ```bash
   terraform plan
   ```
4. **Infrastructure deploy karein**:
   ```bash
   terraform apply -auto-approve
   ```
5. **Infrastructure destroy/delete karein**:
   ```bash
   terraform destroy -auto-approve
   ```
