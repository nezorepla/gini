<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="txtQID" runat="server"></asp:TextBox>
        <asp:Button ID="btnBasla" runat="server" Text="Soru yoksa başlat oyunu" 
            onclick="btnBasla_Click" /><hr />
        <asp:Label ID="lblSoru" runat="server" Text="soru"></asp:Label>
        <hr />
        <asp:Button ID="btnE" CssClass="button" runat="server" Text="Evet" 
            onclick="btnE_Click" />
        <asp:Button ID="btnH" CssClass="button" runat="server" Text="Hayır" 
            onclick="btnH_Click" />
        <asp:Button ID="btnB" CssClass="button" runat="server" Text="Bilmiyorum" 
            onclick="btnB_Click" />
        <asp:Button ID="btnHE" CssClass="button" runat="server" Text="Herhalde" 
            onclick="btnHE_Click" />
        <asp:Button ID="btnHH" CssClass="button" runat="server" Text="Herhalde Değil" 
            onclick="btnHH_Click" />
    </div>
    <asp:Label ID="lblList" runat="server"></asp:Label>
    
    </form>
</body>
</html>
