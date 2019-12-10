Import-Module ActiveDirectory
$inputXML = @"
<Window x:Class="User_Account_Management.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:User_Account_Management"
        mc:Ignorable="d"
        Title="Student Password Reset" Height="318.19" Width="442" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" Background="#FF728BC5"
    <Grid RenderTransformOrigin="0.5,0.5">
        <Grid.RowDefinitions>
            <RowDefinition Height="113*"/>
            <RowDefinition Height="300*"/>
        </Grid.RowDefinitions>
        <Grid.RenderTransform>
            <TransformGroup>
                <ScaleTransform/>
                <SkewTransform/>
                <RotateTransform Angle="-0.274"/>
                <TranslateTransform/>
            </TransformGroup>
        </Grid.RenderTransform>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="48*"/>
            <ColumnDefinition Width="47*"/>
            <ColumnDefinition Width="123*"/>
        </Grid.ColumnDefinitions>
        <TextBox x:Name="UsernameInput" HorizontalAlignment="Left" Height="23" Margin="13,22,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="153" FontFamily="Arial" FontWeight="Bold" AutomationProperties.HelpText="Enter the username/student ID into this field" Grid.Column="2" Background="#FFF3F8FB" FontSize="16" MaxLines="1" MaxLength="11" Text="0000"/>
        <Label x:Name="UserNameLabel" Content="Enter Student ID:" HorizontalAlignment="Left" Margin="71,19,0,0" VerticalAlignment="Top" Width="135" FontFamily="Arial" Grid.ColumnSpan="3" Height="30" FontSize="16" RenderTransformOrigin="0.5,0.5">
            <Label.RenderTransform>
                <TransformGroup>
                    <ScaleTransform/>
                    <SkewTransform AngleX="-1.497"/>
                    <RotateTransform/>
                    <TranslateTransform X="-0.314"/>
                </TransformGroup>
            </Label.RenderTransform>
        </Label>
        <TextBox x:Name="PasswordEntry" HorizontalAlignment="Left" Height="23" Margin="34,0,0,0" TextWrapping="Wrap" Text="Welcome2ThomasRotherham!" VerticalAlignment="Top" Width="229" Background="#FFF3F8FB" Grid.ColumnSpan="3" BorderBrush="Black" Grid.Row="1" />
        <Button x:Name="Action" Content="Reset Password" HorizontalAlignment="Left" Margin="78,62,0,0" VerticalAlignment="Top" Width="126" Height="23" Grid.Column="2" Grid.RowSpan="2"/>
        <Button x:Name="Check" Content="Check" Grid.Column="2" HorizontalAlignment="Left" Height="23" Margin="166,22,0,0" VerticalAlignment="Top" Width="54" FontWeight="Bold"/>
        <Image x:Name="UserImage" HorizontalAlignment="Left" Height="120" Margin="60,58,0,0" VerticalAlignment="Top" Width="130" Stretch="Fill" OpacityMask="Black" Grid.Row="1" Grid.ColumnSpan="2" />
        <Label x:Name="InfoLabel" Content="" Grid.Column="2" HorizontalAlignment="Left" Margin="24,102,0,69" VerticalAlignment="Center" Height="39" Width="196" ScrollViewer.VerticalScrollBarVisibility="Disabled" FontWeight="Bold" Grid.Row="1" FontSize="16"/>
        <Button x:Name="UnlockAccount" Content="Unlock Account" Grid.Column="2" HorizontalAlignment="Left" Height="23" Margin="78,11,0,0" Grid.Row="1" VerticalAlignment="Top" Width="126"/>

    </Grid>
</Window>

"@ 

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

[xml]$XAML = $inputXML

#Read XAML

$reader=(New-Object System.Xml.XmlNodeReader $xaml)

try{

    $Form=[Windows.Markup.XamlReader]::Load( $reader )

}

catch{

    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties in your textboxes (PowerShell cannot process them)"

    throw

}

 

#===========================================================================

# Load XAML Objects In PowerShell

#===========================================================================

  

$xaml.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";

    try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}

    catch{throw}

    }

 

Function Get-FormVariables{

if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}

write-host "Found the following interactable elements from our form" -ForegroundColor Cyan

get-variable WPF*

}

Get-FormVariables

#===========================================================================

# Use this space to add code to the various form elements in your GUI

#===========================================================================

$CurrentUser = $env:USERNAME
$CurrentDate = (Get-Date).ToString('MMM-yyyy')
$CurrentDate2 = (Get-Date).ToString('dd-MM-yy')
$global:CurrentTimeTwo = Get-Date -Format HH:mm
$txt = ".txt"
$LogOutput = $CurrentDate2 + "," + $CurrentTimeTwo + "," + $CurrentUser + ","
$LogfileName = $CurrentDate + $txt
$Logfile = "..\Logs" + $LogfileName


Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

$WPFCheck.Add_Click({
$global:UserName = $WPFUsernameInput.text
$WPFUserImage.Source = $string5
$WPFInfoLabel.Content = ''
IF($global:UserName -like '*0000*'){
    Try{
    $global:UserName = $WPFUsernameInput.text
    $string =".jpg"
    $string2 = "file:\\ INSERT FOLDER PATH HERE $global:UserName"
    $string3 = $string2 + $string
    $string4 = "file:\\ INSERT FOLDER PATH HERE"
    $string5 = $string4 + $string
    $WPFInfoLabel.Visibility = 'Visible'
    $WPFUserImage.Visibility = 'Visible'
    $WPFUserImage.Source = $string3
    $WPFInfoLabel.Content = Get-ADUser -Identity $global:UserName -Properties displayName | Select-Object -ExpandProperty DisplayName
    }
    Catch
    {
    }
  }
ELSE{
    $a = new-object -comobject wscript.shell
    $b = $a.popup("Incorrect ID. ",2,"",0)
}
    

})

$WPFAction.Add_Click({
    $global:UserName = $WPFUsernameInput.text

    IF($global:UserName -like '*0000*'){
        Add-Type -AssemblyName PresentationCore,PresentationFramework
        $ButtonType = [System.Windows.MessageBoxButton]::YesNo
        $MessageIcon = [System.Windows.MessageBoxImage]::Error
        $MessageBody = "Are you sure you want to reset the password for " + $global:UserName + "?"
        $MessageTitle = "Confirm Password Reset"
        $Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
        
        switch($result)
            {
	            "Yes" {
                        Try{
		                $global:UserName = $WPFUsernameInput.text
                        $WPFUserImage.Visibility = 'Hidden'
                        $WPFInfoLabel.Visibility = 'Hidden'
                        $NewPassword = ConvertTo-SecureString -String $WPFPasswordEntry.text -AsPlainText -Force
                        Set-ADAccountPassword $global:UserName -NewPassword $NewPassword -Reset -PassThru | Set-ADuser -ChangePasswordAtLogon $True
                        Unlock-ADAccount -Identity $global:UserName
                        $a = new-object -comobject wscript.shell
                        $b = $a.popup("Password has been changed. ",2,"",0)
                        LogWrite "$LogOutput $global:UserName had their password reset."
                        }
                        Catch{}
                      }
	            "No"  {
		            
                      }
                 }
            }

ELSE{
        $a = new-object -comobject wscript.shell
        $b = $a.popup("Incorrect ID. ",2,"",0)
    }
       
})

$WPFUnlockAccount.Add_Click({
            $global:UserName = $WPFUsernameInput.text
            IF($global:UserName -like '*0000*')
            {

            $WPFUserImage.Visibility = 'Hidden'
            $WPFInfoLabel.Visibility = 'Hidden'
            Unlock-ADAccount -Identity $global:UserName
            $a = new-object -comobject wscript.shell
            $b = $a.popup("User account $global:UserName has been unlocked. ",2,"",0)
            LogWrite "$LogOutput $global:UserName was unlocked."

            }

            ELSE
            {

                $a = new-object -comobject wscript.shell
                $b = $a.popup("Incorrect ID. ",2,"",0)

            }

})



#Action Button to click     

# Results text box that appears





#===========================================================================

# Shows the form

#===========================================================================

write-host "To show the form, run the following" -ForegroundColor Cyan

'$Form.ShowDialog() | out-null'

function Show-Form{

$Form.ShowDialog() | out-null

}
Show-Form
