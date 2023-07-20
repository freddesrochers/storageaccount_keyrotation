
connect-azaccount -identity
Get-AzSubscription
Select-AzSubscription "42fbf850-c9dc-4643-a863-2f086c5fe426"

$sa = Get-AzStorageAccount -ResourceGroupName RG-avjet-2023 -Name sadatafred01



    Write-Output "Rotation For: $($sa.StorageAccountName)" 

    $saKey1 = (Get-AzStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName).Value[0]
    $saKey2 = (Get-AzStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName).Value[1]

    New-AzStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName -KeyName key1
    New-AzStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName -KeyName key2

    $NsaKey1 = (Get-AzStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName).Value[0]
    $NsaKey2 = (Get-AzStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName).Value[1]

    if ($saKey1 -ne $NsaKey1){

        Write-Output "Key1 Successfully Rotated"
        $secretvalue = ConvertTo-SecureString $NsaKey1 -AsPlainText -Force

        $Secret = ConvertTo-SecureString -String 'Password' -AsPlainText -Force
        $Expires = (Get-Date).AddDays(1).ToUniversalTime()
        $NBF =(Get-Date).ToUniversalTime()
        $Tags = @{ 'Severity' = 'High'; 'compte de stockage' = 'sadatafred01'; 'key' = 'Key1'}
        $ContentType = 'txt'
        try
        {
            Set-AzKeyVaultSecret -VaultName 'kvajetiti' -Name 'AvjetRootKey1' -secretvalue $secretvalue -Expires $Expires -NotBefore $NBF -ContentType $ContentType  -Tags $Tags
            Write-Output "Key1 Successfully intergrated in Azure Keyvault"

        }
        catch
        {
            write-warning " key1 error to integrate with Azure keyvault"
        }

        


    } else { Write-Output "Key1 Failed To Rotated" }

    if ($saKey2 -ne $NsaKey2){

        Write-Output "Key2 Successfully Rotated"

    } else { Write-Output "Key2 Failed To Rotated" }


    Write-Output ""




