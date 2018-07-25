Sub StockTracker()
    
    Dim Sheet As Worksheet
    Dim RowCount As Long
    Dim Cnt As Integer
    Dim OpenValue, CloseValue, YearlyChange As Double
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
        MinPercentChange = 0
        MaxStockVolume = 0
        Cnt = 2
        
        RowCount = Sheet.Cells(Rows.Count, 1).End(xlUp).Row + 1
        
        'Populate Summary Table
        For i = 3 To RowCount
            If Sheet.Cells(i, 1).Value <> Sheet.Cells(i - 1, 1).Value Then
                'Ticker Value
                Sheet.Cells(Cnt, 9).Value = Sheet.Cells(i - 1, 1).Value
                
                'Yearly Change
                CloseValue = Sheet.Cells(i - 1, 6).Value
                YearlyChange = CloseValue - OpenValue
                Sheet.Cells(Cnt, 10).Value = YearlyChange
                OpenValue = Sheet.Cells(i, 3).Value
                
                'Percent Change
                If OpenValue <> 0 Then 'Case when Opening Value is greater than zero
                    Sheet.Cells(Cnt, 11).Value = YearlyChange / OpenValue
                    'Check for min/max percent
                    If YearlyChange / OpenValue > MaxPercentChange Then
                        MaxPercentChange = YearlyChange / OpenValue 'Set Max Percent Change
                        MaxPercentTicker = Sheet.Cells(Cnt, 9).Value 'Set Max Ticker Value
                    ElseIf YearlyChange / OpenValue < MinPercentChange Then
                        MinPercentChange = YearlyChange / OpenValue 'Set Min Percent Change
                        MinPercentTicker = Sheet.Cells(Cnt, 9).Value 'Set Max Ticker Value
                    End If
                Else
                    Sheet.Cells(Cnt, 11).Value = "N/A"
                End If
                
                
                'Total Stock Volume
                Sheet.Cells(Cnt, 12).Value = TotalStockVolume
                'Check for Max Stock Volume
                If TotalStockVolume > MaxStockVolume Then
                    MaxStockVolume = TotalStockVolume 'Set Max Stock Volume
                    MaxStockVolumeTicker = Sheet.Cells(Cnt, 9).Value 'Set Max Stock Volume Ticker
                End If
                
                TotalStockVolume = 0
                Cnt = Cnt + 1
                
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

