Sub StockTracker()
    
    Dim Sheet As Worksheet
    Dim RowCount As Long
    Dim Cnt As Integer
    Dim OpenValue, CloseValue As Double
    Dim TotalStockVolume As Double
    Dim MaxPercentChange, MinPercentChange As Double
    Dim MaxStockVolume As Double
    Dim MinPercentTicker, MaxPercentTicker, MaxStockVolumeTicker As String
    
    ' Loop through all of the worksheets in the active workbook.
    For Each Sheet In Worksheets
    
        'Initialize variables
        TotalStockVolume = Sheet.Cells(2, 7).Value
        OpenValue = Sheet.Cells(2, 3).Value
        MaxPercentChange = 0
        MaxTickerValue = ""
        MinPercentChange = 0
        MinTickerValue = ""
        MaxStockVolume = 0
        RowCount = 0
        Cnt = 2
        RowCount = Sheet.Rows.Count
        
        'Populate Summary Table
        For i = 3 To RowCount
            If Sheet.Cells(i, 1).Value <> Sheet.Cells(i - 1, 1).Value Then
                'Ticker Value
                Sheet.Cells(Cnt, 9).Value = Sheet.Cells(i - 1, 1).Value
                
                'Yearly Change
                CloseValue = Cells(i - 1, 6).Value
                Sheet.Cells(Cnt, 10).Value = CloseValue - OpenValue
                
                'Percent Change
                If OpenValue <> 0 Then 'Case when Opening Value is zero
                    Sheet.Cells(Cnt, 11).Value = (CloseValue - OpenValue) / OpenValue
                    'Check for min/max percent
                    If Sheet.Cells(Cnt, 11).Value > MaxPercentChange Then
                        MaxPercentChange = Sheet.Cells(Cnt, 11).Value 'Set Max Percent Change
                        MaxPercentTicker = Sheet.Cells(Cnt, 9).Value 'Set Max Ticker Value
                    ElseIf Sheet.Cells(Cnt, 11).Value < MinPercentChange Then
                        MinPercentChange = Sheet.Cells(Cnt, 11).Value 'Set Min Percent Change
                        MinPercentTicker = Sheet.Cells(Cnt, 9).Value 'Set Max Ticker Value
                    End If
                Else
                    Sheet.Cells(Cnt, 11).Value = "N/A"
                End If
                
                
                'Total Stock Volume
                Sheet.Cells(Cnt, 12).Value = TotalStockVolume
                'Check for Max Stock Volume
                If Sheet.Cells(Cnt, 12).Value > MaxStockVolume Then
                    MaxStockVolume = Sheet.Cells(Cnt, 12).Value 'Set Max Stock Volume
                    MaxStockVolumeTicker = Sheet.Cells(Cnt, 9).Value 'Set Max Stock Volume Ticker
                End If
                
                TotalStockVolume = 0
                Cnt = Cnt + 1
                OpenValue = Sheet.Cells(i, 3).Value
            Else
                TotalStockVolume = TotalStockVolume + Sheet.Cells(i, 7).Value
            End If
        Next i
        
        'Populate min/max table
        Sheet.Cells(2, 15).Value = MaxPercentTicker
        Sheet.Cells(2, 16).Value = MaxPercentChange
        Sheet.Cells(3, 15).Value = MinPercentTicker
        Sheet.Cells(3, 16).Value = MinPercentChange
        Sheet.Cells(4, 15).Value = MaxStockVolumeTicker
        Sheet.Cells(4, 16).Value = MaxStockVolume

    Next

End Sub
