# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Library name...: cl_gre
# Descriptions...: 詢問使用者以何種方式處理報表檔
# Input parameter: p_name   報表檔名稱
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2)
# Modify.........: No:FUN-B70017 11/07/07 By jacklai 在結束GR程式前,刪除程式建立的temp table
# Modify.........: No:FUN-B70118 11/07/29 By jacklai 增加製表日期時間欄與製表者名稱
# Modify.........: No:FUN-B80041 11/08/04 By jacklai 可在4gl指定GR報表樣板
# Modify.........: No:FUN-B80092 11/08/04 By jacklai GR簽核圖檔
# Modify.........: No:FUN-B80097 11/09/02 By jacklai GR背景作業
# Modify.........: No:FUN-BC0063 11/12/19 By jacklai 未與EasyFlow整合的報表改為顯示簽核關卡文字
# Modify.........: No:FUN-BC0113 11/12/27 By jacklai GR列印視窗改為上方顯示報表樣板下方顯示輸出格式
# Modify.........: No:FUN-C10009 12/02/02 By downheal 新增GR報表留存份數判斷(cl_gre_history_save)
#                                                     更改cl_gre_savename
# Modify.........: No:TQC-C20476 12/02/24 By janethuang 報表的報表名稱抓法改為先抓gaz06,若gaz06沒值,再抓gaz03
# Modify.........: No:FUN-C30012 12/03/05 By downheal GR簽核列印與否以及新增明細類判斷
# Modify.........: No:FUN-C30011 12/03/07 By downheal 新增匯出RTF選項;新增按鈕串到Layout Edit;
#                                                     視窗新增勾選選項,選到該筆樣板要顯示打勾; 
# Modify.........: No:FUN-C30255 12/03/21 By downheal 將outputformat改為下拉式清單
# Modify.........: No:FUN-C30259 12/03/22 By downheal 將gdw10改為gfs03所以需要join gfs_file
# Modify.........: No:FUN-C40010 12/04/02 By downheal 新增環境變數以便執行分散模式
# Modify.........: No:FUN-C30109 12/04/03 By janet GR mail to 沒有傳送執行條件改成跟CR一樣
# Modify.........: No:TQC-C40053 12/04/11 By janet 增加WINDOW路徑、呼叫p_gr_javamail
# Modify.........: No:FUN-C40085 12/04/26 By downheal 修正明細類報表,若不須列印簽核則不會執行組簽核字串程式
# Modify.........: No:FUN-C50037 12/05/10 By downheal 簽核新增傳入參數p_template
# Modify.........: No:FUN-C50060 12/05/15 By janet 抓l_host時判斷TAB鍵，新增l_greport變數
# Modify.........: No:FUN-C50099 12/05/24 By odyliao 暫先 mark cl_gr_edit
# Modify.........: No:FUN-C60012 12/06/05 By janet 修改抓.2主機上的4rp路徑、加上gdw08
# Modify.........: No:FUN-C60029 12/06/08 By janet 開窗選擇輸出格式時，依p_zy2的設定控制是否顯示
# Modify.........: No:FUN-C60039 12/06/12 By janet 增加tiptop group可顯示&執行 [自訂樣板]和[產生sampledata]
# Modify.........: No:FUN-C60077 12/07/05 By downheal 標準路徑:tiptop，增加WINTEMPDIR環境變數
# Modify.........: No:TQC-C70039 12/07/11 By downheal 背景作業多加判斷, 若g_prtway不為空才執行
# Modify.........: No:FUN-C70048 12/07/11 By downheal 隱藏controlg按鈕; 匯出格式為SVG才做setTitle()
# Modify.........: No:FUN-C70069 12/07/17 By janet 增加抓取CRIP的判斷是否走DNS、產生歷史報表空檔
# Modify.........: No:FUN-C70120 12/08/17 By janet 增加zv09列印份數、cl_gre_format_combo的x拆開, 背景作業改cl_cmdrun_wait()
# Modify.........: No:FUN-C80015 12/08/29 By janet 歷史報表自定命名功能
# Modify.........: No:FUN-C90106 12/09/24 By janet 讀取/etc/hosts 避免整行mark的資訊
# Modify.........: No:FUN-C90120 12/11/27 By janet GR檢查營運中心LOGO是否存在
# Modify.........: No:FUN-CB0127 12/11/27 By janet 增加API壓縮SVG檔案
# Modify.........: No:FUN-CB0144 12/12/03 By janet g_bgjob 是null判斷,cl_gre第一筆pick=y，其餘n,明細簽核解mark
# Modify.........: No:FUN-D10044 13/01/09 By janet 直接送印改成分散式模式 ,程式優化
# Modify.........: No:FUN-D10077 13/01/16 By odyliao 直接送印增加簽核欄位
# Modify.........: No:FUN-D10109 13/01/24 By janet 增加行業別
# Modify.........: No:FUN-D10108 13/01/28 By odyliao 增加預設樣板排序設定
# Modify.........: No:FUN-D10135 13/01/31 By janet 直接送印增加7種格式
# Modify.........: No:EXT-D30028 13/03/06 By odyliao 增加無樣板時的錯誤提示
# Modify.........: No:FUN-D40008 13/04/02 By janet title2改抓cl_get_reporttitle()
# Modify.........: No:FUN-D40013 13/04/02 By janet title1判斷是否列印營運中心
# Modify.........: No:FUN-D40043 13/04/09 By odyliao 調整樣板排序邏輯

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

#No.FUN-B40095
GLOBALS
    DEFINE ls_outputformat  STRING
    DEFINE li_preview       LIKE type_file.num5
    DEFINE ls_savefilename  STRING
    DEFINE lc_gdw01         LIKE gdw_file.gdw01
    DEFINE g_view_cnt       LIKE type_file.num5
    DEFINE g_gre_progress   STRING
    DEFINE g_receiver_list  STRING
    DEFINE g_cc_list        STRING
    DEFINE g_bcc_list       STRING
    DEFINE g_sendmail       DYNAMIC ARRAY OF RECORD
              format        STRING,
              receiver      STRING,
              cc            STRING,
              bcc           STRING
                            END RECORD
    DEFINE g_mail_cnt       LIKE type_file.num5
    DEFINE g_module         STRING  #FUN-BC0063
    DEFINE ls_savefilename1 STRING  #FUN-C80015  
    
END GLOBALS

DEFINE g_gdw   DYNAMIC ARRAY OF RECORD
       pick    VARCHAR,             #No.FUN-C30127 顯示勾選
       gfs03   LIKE gfs_file.gfs03, #No.FUN-C30127 樣板說明 FUN-C30259 由gdw10改為gfs03
       gdw03   LIKE gdw_file.gdw03, #No.FUN-C30127 客製否
       gdw09   LIKE gdw_file.gdw09, #No.FUN-C30127 樣板代號
       gdw11   LIKE gdw_file.gdw11,
       gdw12   LIKE gdw_file.gdw12,
       gdw13   LIKE gdw_file.gdw13,
       gdw14   LIKE gdw_file.gdw14, #No.FUN-B80092
       gdw15   LIKE gdw_file.gdw15, #No.FUN-B80092
       gdw02   LIKE gdw_file.gdw02, #No.FUN-C30011
       gdw08   LIKE gdw_file.gdw08, #No.FUN-C60012
       gdw05   LIKE gdw_file.gdw05, #使用者   #FUN-D10108
       gdw04   LIKE gdw_file.gdw04, #權限類別 #FUN-D10108
       gdw17   LIKE gdw_file.gdw17  #預設樣板 #FUN-D10108
      ,gdw06   LIKE gdw_file.gdw06  #行業別   #FUN-D40043
       END RECORD
       
DEFINE g_rec_b          LIKE type_file.num10
DEFINE g_sql            STRING
#DEFINE g_cron_job       LIKE type_file.chr1 #No.FUN-B80092
DEFINE g_mail_flag      STRING
DEFINE g_save_flag      STRING
DEFINE g_gre_times      LIKE type_file.num5
DEFINE g_savefilename   STRING
DEFINE g_mail_attach    STRING  #記錄mail附件檔名  #mail
DEFINE g_mail_attach_win,g_gre_filename STRING  #window janet
DEFINE g_db_type        STRING  #FUN-B70017
#DEFINE g_apr_loc        STRING  #No.FUN-B80092 #FUN-C30012 改為系統變數處理
DEFINE g_apr_cnt        LIKE type_file.num5  #紀錄執行列印簽核的次數 #No.FUN-B80092
DEFINE g_bg_cnt         LIKE type_file.num5  #紀錄背景列印簽核的次數 #No.FUN-B80097
DEFINE g_ac             LIKE type_file.num10 #No.FUN-B80097
DEFINE g_gdw01          LIKE gdw_file.gdw01  #FUN-C60029

##################################################
# Library name...: cl_gre_outnam
# Descriptions...: GR列印視窗
# Input parameter: pc_gdw01                 程式代號
# Return code....: om.SaxDocumentHandler    SAX文件處理器物件
# Usage..........: LET l_handler = cl_gre_outname("axmr500")
##################################################
FUNCTION cl_gre_outnam(pc_gdw01)
    DEFINE pc_gdw01     LIKE gdw_file.gdw01
    DEFINE l_ac         LIKE type_file.num5
    DEFINE l_cnt        LIKE type_file.num5
    DEFINE lc_gdw09     LIKE gdw_file.gdw09
    #DEFINE lc_zz011     LIKE zz_file.zz011  #No.FUN-B80097
    DEFINE handler      om.SaxDocumentHandler
    DEFINE ls_path      STRING
    DEFINE ls_path_win  STRING  #janet add
    DEFINE ls_dir       STRING
    DEFINE l_dialog     ui.Dialog
    DEFINE l_sampledata LIKE type_file.chr1
    DEFINE l_rootnode	om.DomNode
    DEFINE l_nodes	om.NodeList
    DEFINE ls_output    STRING
    DEFINE l_i          LIKE type_file.num10 #No.FUN-B80097
    DEFINE l_zz011      LIKE zz_file.zz011   #No.FUN-BC0063
    DEFINE l_save       STRING               #No.FUN-C10009 是否留存歷史報表(Y/N)
    DEFINE l_delete     SMALLINT             #No.FUN-C10009 刪除檔案返回之參數 
    DEFINE l_gaz03      LIKE gaz_file.gaz03, #TQC-C20476 add
           l_gaz06      LIKE gaz_file.gaz06  #TQC-C20476 add
    DEFINE l_str_gaz    STRING               #TQC-C20476 add
    DEFINE l_count      INTEGER              #No.FUN-C30011 計算子報表數量
    DEFINE lc_gdw08     INTEGER              #No.FUN-C30011 報表id,呼叫LayoutEdit用
    DEFINE l_row        INTEGER              #No.FUN-C30011 紀錄列數
    DEFINE l_action     STRING               #No.FUN-C30011 儲存使用者是否按下Layout edit按鈕
    DEFINE l_template_dir STRING             #No.FUN-C40010 GRE Server 樣板目錄
    DEFINE l_FGLPROFILE   STRING             #No.FUN-C40010 GRE FGLPROFILE 目錄   
    DEFINE l_drive_str    STRING             #No.TQC-C40053 存fgl_getenv("TEMPLATEDRIVE")的字串
    DEFINE l_cmd,l_read_str STRING            #No.TQC-C40053
    DEFINE lc_chin       base.Channel         #No.TQC-C40053  
    DEFINE lc_chout         base.Channel      #No.TQC-C40053
    DEFINE lr_host          DYNAMIC ARRAY OF STRING    #No.TQC-C40053
    DEFINE l_l ,i,l_set ,l_set1            LIKE type_file.num5      #No.TQC-C40053
    DEFINE l_crip_temp,l_crip,l_host        STRING            #No.TQC-C40053
    DEFINE l_greport                         STRING             #FUN-C50060 add
    #define l_width_size                     string 
    DEFINE l_mid_dir      STRING              #$TOP或$CUST最後的DIR NAME
    DEFINE l_zy06         LIKE zy_file.zy06   #FUN-C60029
    DEFINE l_chk        LIKE type_file.chr1  #FUN-C60039 add
    DEFINE l_chmodname    STRING             #FUN-C60077 add   
    DEFINE l_grdatetime        DATETIME YEAR  TO SECOND #FUN-C60077 add    
    DEFINE l_sysdatetime       DATETIME YEAR  TO SECOND #FUN-C60077 add 
    DEFINE l_timediff          INTERVAL SECOND TO FRACTION(5)     #FUN-C60077 add
    DEFINE l_grdatetime_str    STRING                     #FUN-C60077 add
    DEFINE l_tok_param         base.StringTokenizer       #FUN-C70069 add    
    DEFINE l_num_arr           DYNAMIC ARRAY OF INTEGER   #FUN-C70069 add 
    DEFINE l_svg_file          base.Channel               #FUN-C70069 add create new svgFile
    DEFINE l_svg_name          STRING                     #FUN-C70069 add 
    DEFINE l_logopath          STRING                     #FUN-C90120 add

    WHENEVER ERROR CONTINUE

    #FUN-C90120 add-(s)
    LET l_logopath = FGL_GETENV("TOP")||"/doc/pic/pdf_logo_",g_dbs CLIPPED,g_rlang CLIPPED,".jpg"
    IF NOT os.Path.exists(l_logopath) THEN
       CALL cl_err('','azz1281',1)
       LET INT_FLAG= TRUE
       LET handler = NULL
       RETURN handler
    END IF
    #FUN-C90120 add-(e)

    
    LET g_gdw01 = pc_gdw01
    SELECT zz011 INTO l_zz011 FROM zz_file WHERE zz01=g_prog   #FUN-BC0063
    LET g_module = l_zz011
    LET handler = cl_gre_zv()

    IF handler IS NOT NULL THEN
        LET INT_FLAG = TRUE
        RETURN handler
    END IF

    IF g_sendmail.getLength() > 0 AND g_mail_cnt = g_sendmail.getLength() THEN
       CALL cl_gre_javamail_prepare(g_mail_cnt)
       LET g_mail_flag = FALSE
       CALL g_sendmail.clear()
       LET g_mail_cnt = 0
    END IF

    IF g_save_flag = "S" THEN
       LET g_save_flag = "N"
       #FUN-C60077--add start
       LET l_chmodname =os.Path.join(FGL_GETENV("TEMPDIR"),os.Path.basename(g_savefilename))
       #DISPLAY "l_chmodname:",l_chmodname       
       LET l_sysdatetime = CURRENT  YEAR  TO SECOND  #系統現在時間
       CALL os.Path.mtime(l_chmodname) RETURNING l_grdatetime  #svg最後修改時間         
       LET l_timediff = l_sysdatetime - l_grdatetime    
       #DISPLAY "l_sysdatetime:",l_sysdatetime       
       #DISPLAY "l_grdatetime:",l_grdatetime
       #DISPLAY "l_timediff:",l_timediff

       IF os.Path.exists(l_chmodname) AND os.Path.size(l_chmodname)>0 AND l_timediff>216000 THEN #svg檔案存在，且size>0，且上次修改時間超過6小時
           RETURN NULL 
       END IF 
       


           IF os.Path.chrwx(l_chmodname ,511) THEN
              #DISPLAY l_chmodname,"flag=s chmod ok"
           #FUN-C60077--add end
           #IF os.Path.chrwx(g_savefilename ,511) THEN #FUN-C60077 mark
              #開放權限
           END IF
    END IF
   
    DISPLAY "g_prtway: ", g_prtway   #TQC-C70039 列印以方便除錯 
    IF g_mail_flag OR g_save_flag="Y" OR (g_bgjob="Y" AND NOT cl_null(g_prtway)) THEN #No.FUN-B80097 add g_bgjob #TQC-70039 add
       #No.FUN-B80097 --start-- #背景作業設定
       IF g_bgjob = "Y" THEN
          LET g_bg_cnt = g_bg_cnt + 1
          IF g_bg_cnt <= 1 THEN
             LET lc_gdw09 = NULL
             LET l_ac = 0
             CALL cl_gre_b_fill()

             #有設定樣版名稱時要比對樣板名稱
             IF NOT cl_null(g_rpt_name) THEN
                FOR l_i = 1 TO g_gdw.getLength()
                   IF g_gdw[l_i].gdw09 = g_rpt_name THEN
                      LET l_ac = l_i
                      LET lc_gdw09 = g_gdw[l_i].gdw09
                      EXIT FOR
                   END IF
                END FOR
             ELSE #未設定樣板名稱時抓第一筆
                IF g_gdw.getLength() >= 1 THEN
                   LET l_ac = 1
                   LET lc_gdw09 = g_gdw[l_ac].gdw09
                END IF
             END IF
             IF l_ac > 0 THEN
                LET li_preview = 0
                CALL cl_gre_mail()
             ELSE
                LET INT_FLAG = TRUE
                LET g_bg_cnt = 0
                RETURN NULL
             END IF
          END IF

          IF g_bg_cnt = 1 AND g_sendmail.getLength() = 0 THEN
             LET g_save_flag = "Y"
          END IF

          #計算背景作業執行的次數,次數滿之後跳出cl_gre_outnam()
          IF g_bg_cnt > g_sendmail.getLength() AND g_sendmail.getLength() >= 0 AND g_bg_cnt > 1 THEN
             LET INT_FLAG = TRUE
             LET g_bg_cnt = 0
             RETURN NULL
          END IF
       END IF
       #No.FUN-B80097 --end--
       IF g_save_flag="Y" THEN
          LET li_preview = 0
          LET l_sampledata = "N"
          LET l_ac = 1
       END IF

 
       IF g_mail_flag THEN
          IF g_mail_cnt <= g_sendmail.getLength() THEN
             IF g_mail_cnt > 0 THEN
                CALL cl_gre_javamail_prepare(g_mail_cnt)
             END IF
             LET g_mail_cnt = g_mail_cnt + 1

             # 迴圈指定handler, 跑完以後再回到outnam送信
             CASE g_sendmail[g_mail_cnt].format
                WHEN "1" LET ls_outputformat = "2"
                WHEN "2" LET ls_outputformat = "3"
                WHEN "3" LET ls_outputformat = "4" 
                WHEN "4" LET ls_outputformat = "5" #No.FUN-C30255 xlsx
                WHEN "5" LET ls_outputformat = "6" #No.FUN-C30255 xlsx
                WHEN "6" LET ls_outputformat = "7" #No.FUN-C30255 rtf
                WHEN "7" LET ls_outputformat = "8" #No.FUN-C30255 html
                OTHERWISE LET ls_outputformat = "2" #No.FUN-B80097 格式預設為PDF
             END CASE
             LET li_preview = 0
             LET l_sampledata = "N"
             LET ls_savefilename = os.Path.join(FGL_GETENV("TEMPDIR"),"output")
             #DISPLAY "add output ls_savefilename:",ls_savefilename
             LET l_ac = 1
          END IF
       END IF
       #No.FUN-B80097 --start--
       IF g_ac > 0 THEN        
         LET l_ac = g_ac
       END IF
       #No.FUN-B80097 --end--
    ELSE

       LET lc_gdw01 = pc_gdw01 CLIPPED
       LET l_rootnode = ui.Interface.getRootNode()
      #LET l_greport = l_rootnode.toString()
       LET l_nodes = l_rootnode.selectByPath("//Window[@name=\"cl_gre_w\"]")
       IF l_nodes.getLength() <= 0 THEN

          OPEN WINDOW cl_gre_w WITH FORM "lib/42f/cl_gre"
            ATTRiBUTE(STYLE="lib")
       END IF

       CALL cl_ui_locale("cl_gre")
       CALL cl_load_style_list(NULL)   #FUN-C70048 cmdrun cl_gre視窗風格
       CALL cl_load_act_sys(NULL)      #FUN-C70048


       LET ls_outputformat = "1"
       LET li_preview = 1
       LET l_sampledata = "N"
       LET ls_savefilename = os.Path.join(FGL_GETENV("TEMPDIR"),"output")
       LET l_count = 1

       #FUN-C60029 ----------start---
       CALL cl_gre_zy06() RETURNING l_zy06
       CALL cl_gre_format_combo(l_zy06,'outputformat','a')
       #FUN-C60029 -----------end----
       
       #暫時隱藏自訂樣板選項
       #CALL cl_set_comp_visible("layout_edit",FALSE) #No.FUN-C40010 add #close layout editor
         
       #若非TIPTOP權限則不顯示sampledata選項 No.FUN-C30011
       #No.FUN-C30011 --START-- 
       #FUN-C60039 add-start---
        CALL cl_gre_chk_tiptopgroup() RETURNING l_chk  #判斷tiptop群組
       IF (g_user = 'tiptop') OR l_chk = 'Y'  THEN   
           CALL cl_set_comp_visible("layout_edit",TRUE)
           CALL cl_set_comp_visible("sampledata",TRUE) 
       else 
            CALL cl_set_comp_visible("layout_edit",FALSE) 
            CALL cl_set_comp_visible("sampledata",FALSE)  
       END IF  
       #FUN-C60039 add-end ---
       #FUN-C60039 mark-start----
       #IF (g_user != 'tiptop') THEN  
         #CALL cl_set_comp_visible("layout_edit",FALSE) #No.FUN-C40010 add  #open layout editor 
         #CALL cl_set_comp_visible("sampledata",FALSE)
       #else
           #CALL cl_set_comp_visible("layout_edit",TRUE) # 120517 janet add    
       #END IF
        #FUN-C60039 mark-start----
       #No.FUN-C30011 -- END --

       DISPLAY ls_outputformat
            TO outputformat

       #判斷g_template是否有值,有值不顯示選樣版畫面 #No.FUN-B80041
       IF cl_null(g_template) THEN #No.FUN-B80041
           SELECT COUNT(*) INTO l_cnt FROM gdw_file
            WHERE gdw01=g_prog

           IF l_cnt > 0 THEN
              CALL cl_gre_b_fill()
           ELSE
              LET l_sampledata = "Y"
              #LET g_gdw[1].gdw02=g_prog
              LET g_rec_b = 1
           END IF
       #No.FUN-B80041 --start--
       ELSE
           #檢查g_template是否存在gdw_file中
           SELECT COUNT(*) INTO l_cnt FROM gdw_file WHERE gdw01=g_prog AND gdw02=g_template
           IF l_cnt <= 0 THEN
              #EXT-D30028 add---(S)
               CALL cl_err(g_template,'lib-628',1)
               LET INT_FLAG=TRUE
              #EXT-D30028 add---(E)
               RETURN NULL
           ELSE
               CALL cl_gre_b_fill()
           END IF
       END IF

       #檢查cl_gre_b_fill取出的g_gdw陣列是否只有一筆, 單筆狀況不顯示選擇樣板畫面
       IF g_gdw.getLength() = 1 THEN
           #CALL cl_set_comp_visible("s_gdw",FALSE) #No.FUN-B80097
           #CALL cl_set_comp_visible("PageTemplate",FALSE) #No.FUN-B80097 #FUN-BC0113

           #因跳過顯示畫面, 須先指定值給lc_gdw09
           LET lc_gdw09 = g_gdw[1].gdw09
       #ELSE    #FUN-BC0113
           #CALL cl_set_comp_visible("s_gdw",TRUE) #No.FUN-B80097
           #CALL cl_set_comp_visible("PageTemplate",TRUE) #No.FUN-B80097 #FUN-BC0113
       END IF
       #No.FUN-B80041 --end--
       
       
       DIALOG ATTRIBUTE(UNBUFFERED)

           DISPLAY ARRAY g_gdw TO s_gdw.* ATTRIBUTE(COUNT = g_rec_b)
           
               #No.FUN-C30127 ---START---
               BEFORE DISPLAY
                  LET l_action = ''
                  LET l_count = ''
                  LET g_gdw[1].pick = 'Y'        #初始狀態第一行必勾選
                  IF g_gdw.getLength() != 1 THEN #若不只一筆樣板檔
                     FOR l_count = 2 TO g_gdw.getLength() #其餘筆數均預設不勾選
                        LET g_gdw[l_count].pick = 'N'
                     END FOR
                     CALL g_gdw.deleteElement(l_count)    #刪除系統自動產生的最後一筆空行
                     LET l_ac = 1
                  END IF
               
                  
               BEFORE ROW
                  IF g_gdw.getLength() != 1 AND l_ac != 0 THEN       #若不只一筆樣板檔
                     IF l_ac != l_dialog.getCurrentRow("s_gdw") THEN #選擇新筆資料時
                        LET g_gdw[l_ac].pick = 'N'                   #將上筆取消勾選
                        LET l_ac = l_dialog.getCurrentRow("s_gdw")   #取得新筆行數
                        LET g_gdw[l_ac].pick = 'Y'                   #新筆設置為勾選
                     END IF
                  END IF


               AFTER ROW
                  LET l_ac = l_dialog.getCurrentRow("s_gdw")
               #No.FUN-C30127 -- END --
               
           END DISPLAY

           INPUT ls_outputformat,l_sampledata
               FROM outputformat,sampledata
               ATTRIBUTE(WITHOUT DEFAULTS)

              ON CHANGE outputformat
               #  IF ls_outputformat = "Mail" THEN
               #     LET li_preview = "0"
               #     DISPLAY li_preview TO preview
               #     CALL l_dialog.setFieldActive("preview",0)
               #     CALL l_dialog.setFieldActive("savefilename",0)
               #     CALL l_dialog.setFieldActive("sampledata",0)
               #  ELSE
               #     CALL l_dialog.setFieldActive("preview",1)
               #     CALL l_dialog.setFieldActive("savefilename",1)
                #    CALL l_dialog.setFieldActive("sampledata",1)
                # END IF

                 #IF ls_outputformat = "Image" OR ls_outputformat = "Mail" THEN    #11/06/03 jacklai, remove image
                 IF ls_outputformat = "Mail" THEN                                  #11/06/03 jacklai, remove image
                    LET li_preview = "0"
                 END IF

              #ON CHANGE preview
              #   IF ls_outputformat = "Image" THEN
              #      LET li_preview = "0"
              #      DISPLAY li_preview TO preview
              #   END IF

              #ON CHANGE sampledata
              #   IF l_sampledata = "Y" THEN
              #      CALL l_dialog.setFieldActive("outputformat",0)
              #      CALL l_dialog.setFieldActive("preview",0)
              #      CALL l_dialog.setFieldActive("savefilename",0)
              #   ELSE
              #      CALL l_dialog.setFieldActive("outputformat",1)
              #      CALL l_dialog.setFieldActive("preview",1)
              #      CALL l_dialog.setFieldActive("savefilename",1)
              #   END IF
           END INPUT

           BEFORE DIALOG
               LET l_dialog = ui.Dialog.getCurrent()
               #IF l_sampledata = "Y" THEN
               #    CALL l_dialog.setFieldActive("outputformat",0)
               #    CALL l_dialog.setFieldActive("preview",0)
               #    CALL l_dialog.setFieldActive("savefilename",0)
               #END IF
               #IF li_preview = 1 THEN
               #   CALL l_dialog.setFieldActive("savefilename",0)
               #END IF

           ON IDLE g_idle_seconds
               CALL cl_on_idle()

           #FUN-C70048 mark --START--
           #ON ACTION controlg
               #CALL cl_cmdask()
           #FUN-C70048 mark -- END --
           
           #TQC-C40053 mark  COCO:先mark  #120517 janet add-start
           ON ACTION layout_edit #FUN-C30011 新增按鈕串到Layout Editor
           #No.FUN-C30011
              LET l_ac = l_dialog.getCurrentRow("s_gdw")
              LET l_action = 'layout_edit'
              ACCEPT DIALOG
           #TQC-C40053 mark  COCO:先mark   #120517 janet add-end

           ON ACTION ACCEPT
               ACCEPT DIALOG

           ON ACTION CANCEL
               LET INT_FLAG = TRUE
               EXIT DIALOG

           ON ACTION CLOSE
               LET INT_FLAG = TRUE
               EXIT DIALOG

           #FUN-D10108 add---(S)
           ON ACTION set_default
               IF cl_gre_set_default(l_ac) THEN
                  LET l_ac=1
                  CALL DIALOG.setCurrentRow("s_gdw", l_ac) #FUN-D10108
               END IF
               #CONTINUE DIALOG
           #FUN-D10108 add---(E)
       END DIALOG
    END IF

    IF INT_FLAG THEN
        #LET INT_FLAG = FALSE
        LET handler = NULL
    ELSE
    
        #FUN-CB0144 add-(s)
        for i= 1 to g_gdw.getLength()
            if g_gdw[i].pick='Y' then
               LET l_ac=i
               EXIT FOR
            END IF
        end for
        #FUN-CB0144 add-(e)
        #No.FUN-B80041 --start--
        #LET lc_gdw09 = g_gdw[l_ac].gdw09 CLIPPED,".4rp"
        IF cl_null(lc_gdw09) THEN
            LET lc_gdw09 = g_gdw[l_ac].gdw09 CLIPPED
        END IF
        
        #當g_gdw筆數為1時, 不會進入畫面, 故人工指定到第1筆
        IF g_gdw.getLength() = 1 THEN
            LET l_ac = 1
        END IF
        #No.FUN-B80041 --end--

        LET g_ac = l_ac #No.FUN-B80097

        #No.FUN-B80092 --start--
        IF g_apr_cnt = 0 THEN
            CALL cl_gre_get_apr_loc(g_gdw[l_ac].gdw14,g_gdw[l_ac].gdw15) 
               RETURNING g_grPageHeader.g_apr_loc   #FUN-C30012 簽核列印位置
           # CALL cl_gr_make_apr(g_gdw[l_ac].gdw09)  #FUN-C50037 傳入樣板代號  #FUN-C60012 mark
            CALL cl_gr_make_apr(g_gdw[l_ac].gdw08)     #FUN-C60012 add
        END IF
        
        CALL cl_gre_get_apr_loc(g_gdw[l_ac].gdw14,g_gdw[l_ac].gdw15) 
               RETURNING g_grPageHeader.g_apr_loc   #FUN-C30012 簽核列印位置

        #FUN-C30012 明細類報表組簽核字串   
        #CALL cl_gre_apr_str(g_gdw[l_ac].gdw09)      #FUN-C50037 傳入樣板代號#FUN-C60012 mark
       # DISPLAY "g_gdw08",g_gdw[l_ac].gdw08
        CALL cl_gre_apr_str(g_gdw[l_ac].gdw08)       #FUN-C60012 add
        LET g_apr_cnt = g_apr_cnt + 1
        #No.FUN-B80092 --end--

        #LET ls_path = cl_gre_get_4rpdir(g_prog,g_gdw[l_ac].gdw03) #No.FUN-B80097 #janet mark
        LET ls_path = cl_gre_get_4rpdir(g_prog,g_gdw[l_ac].gdw03,"L") #No.FUN-B80097 #janet add
        #No.FUN-B80097 --start--
        #IF g_user!='downheal' THEN #FUN-C40010
        
        IF NOT os.Path.exists(ls_path) THEN
             CALL cl_err(ls_path,'azz-056',1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time
             EXIT PROGRAM -1
        #END IF                     #FUN-C40010
        END IF  
        #No.FUN-B80097 --end--
        LET ls_dir  = ls_path
        LET ls_path = os.Path.join(ls_path.trim(),g_lang CLIPPED)
        LET ls_path = os.Path.join(ls_path,lc_gdw09||".4rp") #No.FUN-B80041
        DISPLAY 'ls_path: ', ls_path   #FUN-C40010
        IF os.Path.exists(ls_path) THEN     
            IF fgl_report_loadCurrentSettings(ls_path) THEN END IF

            IF g_save_flag ="Y" THEN
               LET ls_outputformat = "1" # 一律用SVG
               IF cl_null(g_savefilename) THEN  #FUN-C60077 add
                   LET ls_savefilename = cl_gre_savename(g_prog,g_gdw[l_ac].gdw08) #設定歷史留存的檔名 #FUN-C80015 add,g_gdw[l_ac].gdw08
                   LET ls_savefilename1=ls_savefilename
                   #DISPLAY "ls_savefilename:",ls_savefilename
                   #LET ls_savefilename = os.Path.join(fgl_getenv("TEMPDIR"),ls_savefilename) # FUN-C60077 mark
                   LET ls_savefilename = os.Path.join(fgl_getenv("WINTEMPDIR"),ls_savefilename)  # FUN-C60077 add
                   #DISPLAY "TEMPDIR PATH:",fgl_getenv("TEMPDIR")
                   #DISPLAY "TEMPDIR, ls_savefilename:",ls_savefilename
                   LET g_savefilename = ls_savefilename
                   

                   #create new svg file and chmod 777
                   #FUN-C70069 ---add ---start
                   #先產生歷史報表同檔名的空檔案
                   #LET l_svg_name=os.Path.join(fgl_getenv("TEMPDIR"),cl_gre_savename(g_prog)) #FUN-C80015 mark
                    LET l_svg_name=os.Path.join(fgl_getenv("TEMPDIR"),ls_savefilename1)         #FUN-C80015 add
                   IF NOT os.Path.exists(l_svg_name) THEN 
                       LET l_svg_file=base.channel.create()
                       CALL l_svg_file.setdelimiter("")
                       CALL l_svg_file.openfile(l_svg_name CLIPPED, "w" )
                       CALL l_svg_file.close()                      
                   END IF 

                   IF os.Path.chrwx(l_svg_name,511) THEN END IF  #修改權限
                   #FUN-C70069 ---add ---end
                   
               END IF  #FUN-C60077 add
               #No.FUN-B80041 add START 檔案輸出前先做刪除舊檔動作
               CALL os.Path.delete(g_savefilename) RETURNING l_delete
               IF l_delete = 1 THEN
                  DISPLAY 'delete from:', g_savefilename
               END IF
               #No.FUN-B80041 add END
               
               CALL fgl_report_setOutputFileName(ls_savefilename) ##

            END IF

            IF l_ac > 0 AND g_gdw[l_ac].gdw11 = "Y" THEN
                CALL fgl_report_selectLogicalPageMapping("labels")
                CALL fgl_report_setPaperMargins("5mm","5mm","4mm","4mm")
                CALL fgl_report_configureLabelOutput("a4width","a4length",NULL,NULL,
                                                    g_gdw[l_ac].gdw12,
                                                    g_gdw[l_ac].gdw13)
            END IF
            ##TQC-C40053 mark  COCO:先mark----120517 janet add-start
            #No.FUN-C30011   --START--  根據報表id呼叫Layout Editor
      #FUN-C50099 暫時先 MARK----------(S)
           IF (l_action = 'layout_edit') THEN #若按下按鈕
              SELECT gdw08 INTO lc_gdw08 FROM gdw_file WHERE gdw01 = g_prog
                                                       AND gdw02 = g_gdw[l_ac].gdw02
                                                       AND gdw03 = g_gdw[l_ac].gdw03
                                                       AND gdw09 = g_gdw[l_ac].gdw09  
              CALL cl_gr_edit(lc_gdw08) #呼叫Layout Editor
           #No.FUN-C30011   -- END -- 
           
           ELSE
      #FUN-C50099 暫時先 MARK----------(S)
            ##TQC-C40053 mark  COCO:先mark---- 120517 janet add-end
              CASE ls_outputformat
                #WHEN "XML"
                #    --configure the report engine to output the XML file
                #    IF NOT ls_savefilename.getIndexOf(".xml",1) THEN
                #        LET ls_savefilename = ls_savefilename,".xml"
                #    END IF
                #    LET handler = fgl_report_createProcessLevelDataFile(ls_savefilename)

                #WHEN "7"   #11/06/03 jacklai, remove image
                WHEN "9"    #No.FUN-C30255 改到第九項
                    CALL cl_gre_mail() 

                OTHERWISE

                    
                    #120512 janet add
                       #
                      #if g_user="downheal" then
                           #let l_width_size="25cm"
                           #CALL fgl_report_configurePageSize (l_width_size,"30cm")
                      #end if 
                    #120512 janet add
                    

                    #TQC-C20476 -ADD-START
                    #報表名稱抓法改為先抓gaz06,若gaz06沒值,再抓gaz03
                    SELECT gaz03,gaz06 INTO l_gaz03,l_gaz06 FROM gaz_file
                     WHERE gaz01=g_prog AND gaz02=g_rlang
                    IF cl_null(l_gaz06) THEN
                       LET l_gaz06 = l_gaz03 CLIPPED
                    END IF  
                    LET l_str_gaz=l_gaz06,"(", g_prog,")"
                    #CALL fgl_report_setTitle(l_str_gaz)        #FUN-C70048 mark
                    #TQC-C20476 -ADD-END     
                
                    CASE ls_outputformat
                       WHEN "1"
                          LET ls_output = "SVG"
                          CALL fgl_report_setTitle(l_str_gaz)   #FUN-C70048 add 匯出是SVG格式才執行此API
                          #CALL fgl_report_configureSVGdevice(NULL,NULL,FALSE,NULL)  #janet 130315 test
                          CALL fgl_report_setSVGCompression(TRUE)  #FUN-CB0127 add 壓縮svg檔案
                       WHEN "2"
                          LET ls_output = "PDF"
                       WHEN "3" #合併one page
                          LET ls_output = "XLS"
                          CALL fgl_report_configureXLSDevice(1,100000, true,true,true,true,TRUE)
                       WHEN "4" #分成多頁
                          LET ls_output = "XLS"
                       WHEN "5" #No.FUN-C30255 新增XLSX格式
                          LET ls_output = "XLSX"
                          CALL fgl_report_configureXLSXDevice(1,100000, true,true,true,true,TRUE)
                       WHEN "6" #No.FUN-C30255 新增XLSX格式
                          LET ls_output = "XLSX"
                       WHEN "7"                  #No.FUN-C30255 改到第七項
                           LET ls_output = "RTF" #No.FUN-C30011 多加一個選項匯出WORD   
                           CALL fgl_report_setTitle(l_str_gaz)                      
                       WHEN "8"                  #No.FUN-C30255 改到第八項
                          LET ls_output = "HTML"
                          
                       #11/06/03 jacklai, remove image --start--
                       #WHEN "6"
                       #   LET li_preview = "0"
                       #   LET ls_output = "Image"
                       #11/06/03 jacklai, remove image --end--

                    END CASE

                        CALL fgl_report_selectDevice(ls_output)
                        CALL fgl_report_selectPreview(li_preview)

                    #12/12/20 janet for test paper orientation -(s)
                    #CALL fgl_report_setPrinterOrientationRequested("landscape")
                    #12/12/20 janet for test paper orientation -(e)

                    
                    ###   No.FUN-110608  start
                    IF g_sendmail.getLength() > 0 THEN

                        #No.FUN-B80097 --start--
                        #11/09/23規格變更,改抓[g_prog]_[日期]_[時間]
                        #LET g_mail_attach = FGL_GETENV("TEMPDIR"),"/", cl_gre_getServerUID()
                        LET g_gre_filename=cl_gre_jmail_filename() #TQC-C40053 add
                       # LET g_mail_attach = FGL_GETENV("TEMPDIR"),os.Path.separator(),cl_gre_jmail_filename() #TQC-C40053 mark #FUN-C60077 mark
                        LET g_mail_attach = FGL_GETENV("TEMPDIR"),os.Path.separator(),g_gre_filename   #FUN-C60077 add
                
                        #DISPLAY "FGL_GETENV(TEMPDIR):",FGL_GETENV("TEMPDIR") #TQC-C40053 add
                        #DISPLAY "jmail_filename:",g_gre_filename   #TQC-C40053  add
                        #DISPLAY "g_mail_attach:",g_mail_attach   #TQC-C40053  add
                        
                        LET g_mail_attach_win=""  #TQC-C40053  add
                       # DISPLAY "初值_g_mail_attach:",g_mail_attach_win  #TQC-C40053  add
                        LET l_drive_str=fgl_getenv("TEMPLATEDRIVE")
                        #DISPLAY "@@@@@@l_drive_str:",l_drive_str #,"   3: ",l_drive_str.subString(1,3)#TQC-C40053  add #FUN-C60077  mark
                        #LET g_mail_attach_win =l_drive_str.subString(1,2) ,fgl_getenv("TEMPDIR"),os.Path.separator(),g_gre_filename#TQC-C40053  add # FUN-C60077mark
                        LET g_mail_attach_win =os.Path.join(l_drive_str,fgl_getenv("WINTEMPDIR")),os.Path.separator(),g_gre_filename# FUN-C60077 add
                       # LET g_mail_attach_win = "Z:\out53",os.Path.separator(),g_gre_filename#TQC-C40053  mark
                        #DISPLAY "AA_g_mail_attach_win:",g_mail_attach_win   #TQC-C40053  add
                        #DISPLAY "AA_jmail_filename:",g_gre_filename   #TQC-C40053  add
                        CALL fgl_report_setOutputFileName(g_mail_attach_win)

                        #No.FUN-B80097 --end--
                    ELSE
                        LET g_mail_attach = NULL
                    END IF
                    ###   No.FUN-110608  end


                    IF l_sampledata = "Y" THEN
                       IF g_view_cnt > 50 THEN
                          LET g_gre_progress = 'Y'
                          CALL cl_progress_bar(2)
                       END IF
                       LET handler = cl_gre_sampledata(ls_dir,g_gdw[l_ac].gdw09)
                       CALL cl_err('','azz-911',1)
                    ELSE
                            #No.FUN-C40010 --START-- 路徑改抓動態
                            #組report location path/file name

                            CALL cl_gre_setRemoteLocations(g_prog,g_gdw[l_ac].gdw03,lc_gdw09)#FUN-D10044 程式優化
                          ##FUN-D10044 mark-(s)
                          #TQC-C40053 add---start----
                            #LET ls_path_win = cl_gre_get_4rpdir(g_prog,g_gdw[l_ac].gdw03,"W") #No.FUN-B80097 
                            ##DISPLAY '1.ls_path_win:', ls_path_win
                             #
                            #LET ls_dir  = ls_path_win
                            #LET ls_path_win = os.Path.join(ls_path_win.trim(),g_lang CLIPPED)
                            ##DISPLAY '2.ls_path_win:', ls_path_win
                            #LET ls_path_win = os.Path.join(ls_path_win,lc_gdw09||".4rp") #No.FUN-B80041
                            ##DISPLAY '3.ls_path_win: ', ls_path_win   #FUN-C40010 
                            ##LET l_template_dir = FGL_GETENV("TEMPLATEDRIVE"), ls_path_win #FUN-C60012 mark
                            ##FUN-C60012 add--start
                               #IF g_gdw[l_ac].gdw03="Y" THEN #客製
                                  #LET l_mid_dir=os.Path.basename( FGL_GETENV("CUST"))
                               #ELSE 
                                  #LET l_mid_dir="tiptop"   #FUN-C60077 add
                                  ##LET l_mid_dir=os.Path.basename( FGL_GETENV("TOP"))    #FUN-C60077 mark
                               #END IF
                                #LET l_template_dir = os.Path.join(FGL_GETENV("TEMPLATEDRIVE"),l_mid_dir), ls_path_win
                                ##FUN-C60077 mark
                                ##LET l_template_dir = os.Path.join("Z:/",l_mid_dir), ls_path_win
                            ##FUN-C60012 add-end  
                          ##TQC-C40053 add---end ----
                            ##LET l_template_dir = FGL_GETENV("TEMPLATEDRIVE"), ls_path  #TQC-C40053 mark
                            ##DISPLAY 'l_template_dir: ',l_template_dir
                            ##DISPLAY 'WINFGLPROFILE: ',FGL_GETENV("WINFGLPROFILE")
                            ##DISPLAY 'WINFGLDIR:', FGL_GETENV("WINFGLDIR")
                            ##DISPLAY 'WINGREDIR:', FGL_GETENV("WINGREDIR")
#
                            #IF ((NOT cl_null(FGL_GETENV("TEMPLATEDRIVE"))) AND (NOT cl_null(FGL_GETENV("WINFGLPROFILE")))
                                #AND (NOT cl_null(FGL_GETENV("WINFGLDIR"))) AND (NOT cl_null(FGL_GETENV("WINGREDIR")))) THEN
                               ##LET l_template_dir="Z:/topprod/agl/4rp/0/aglg903.4rp"
                               ##DISPLAY "in:l_template_dir:",l_template_dir
                             #CALL fgl_report_configureRemoteLocations(l_template_dir,FGL_GETENV("WINFGLPROFILE"),    
                                                                       #FGL_GETENV("WINFGLDIR"),FGL_GETENV("WINGREDIR"))
                            ##DISPLAY "---------------------------------"                                   
                            ##DISPLAY 'l_template_dir: ',l_template_dir
                            ##DISPLAY 'WINFGLPROFILE: ',FGL_GETENV("WINFGLPROFILE")
                            ##DISPLAY 'WINFGLDIR:', FGL_GETENV("WINFGLDIR")
                            ##DISPLAY 'WINGREDIR:', FGL_GETENV("WINGREDIR")                                                                       
                            #ELSE
                               #CALL cl_err('','azz1201',1)
                               #CALL cl_used(g_prog,g_time,2) RETURNING g_time
                               #EXIT PROGRAM -1
                            #END IF
                            ##TQC-C40053 ADD-START
#
                              ##讀檔
                              #LET l_crip_temp=""
                              #LET l_crip_temp=fgl_getenv('CRIP')
                              #LET l_crip_temp=cl_replace_str(l_crip_temp,"http://","")
                              #LET l_set=l_crip_temp.getIndexOf("/",1) #抓出/位置                              
                              #LET l_crip_temp=l_crip_temp.subString(1,l_set-1) #抓出ip
                              ##FUN-C70069 add---start
                             ## DISPLAY "#l_cRIP_TEMP:",l_crip_temp
                              #IF g_user="tiptop" THEN 
                                   #LET l_tok_param = base.StringTokenizer.createExt(l_crip_temp,".","",TRUE)
                                   #LET i=0
                                   #CALL l_num_arr.clear()
                                   #WHILE l_tok_param.hasMoreTokens()
                                      ##DISPLAY l_tok_table.nextToken()
                                      #LET i=i+1
                                      #LET l_num_arr[i] =l_tok_param.nextToken()  
                                     ## DISPLAY i,"l_num_arr:",l_num_arr[i] 
                                   #END WHILE
                                   ##DISPLAY "EXIT WHILE I=",i
                                   #IF i=3 AND l_num_arr[1] IS NULL AND l_num_arr[2] IS NULL AND l_num_arr[3] IS NULL   THEN
                                      #LET l_host=l_crip_temp  
                                     ## DISPLAY "DNS:l_crip_temp:",l_crip_temp
                                   #ELSE   
                                     ## DISPLAY "IP:l_crip_temp:",l_crip_temp
                                      #LET l_cmd = "/etc/hosts"      
                                      ##DISPLAY l_cmd
                                      #LET lc_chin = base.Channel.create() #create new 物件
                                      #CALL lc_chin.openFile(l_cmd,"r") #開啟檔案
                                      #LET l_l=1
#
                                      #WHILE TRUE   
                                             #LET l_read_str =lc_chin.readLine() #整行讀入
                                             #LET l_read_str = l_read_str.trim()       # FUN-C90106 add
                                             #IF l_read_str.getCharAt(1) <> '#' THEN   # FUN-C90106 add
                                                 #IF l_read_str.getIndexOf(l_crip_temp,1)>0 THEN #找到此ip 
                                                    ##DISPLAY "crip_temp:",l_crip_temp.getLength()+1
                                                    ##DISPLAY "l_read_str:",l_read_str.getLength()
                                                    #LET l_host=l_read_str.substring(l_crip_temp.getLength()+1,l_read_str.getLength() )
                                                    #
                                                    ##DISPLAY "AA_l_host:",l_host
                                                    #LET l_host=cl_replace_str(l_host," ","") #FUN-C50060 add
                                                    #LET l_host=cl_replace_str(l_host,"\t","") #FUN-C50060 add
                                                    #LET l_host=l_host.trim()
                                                    #EXIT WHILE 
                                                 #END IF 
                                             #END IF # FUN-C90106 add
                                             #IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
                                      #END WHILE                              
                                      #CALL lc_chin.close()
#
                                   #END IF  
                              #ELSE 
                              ##FUN-C70069 add---end 
                                     ## DISPLAY "IP:l_crip_temp:",l_crip_temp
                                      #LET l_cmd = "/etc/hosts"      
                                      ##DISPLAY l_cmd
                                      #LET lc_chin = base.Channel.create() #create new 物件
                                      #CALL lc_chin.openFile(l_cmd,"r") #開啟檔案
                                      #LET l_l=1
#
                                      #WHILE TRUE   
                                             #LET l_read_str =lc_chin.readLine() #整行讀入
                                             #LET l_read_str=l_read_str.trim()       #FUN-C90106 ADD
                                             #IF l_read_str.getCharAt(1)<> "#" THEN  #FUN-C90106 ADD
                                                 #IF l_read_str.getIndexOf(l_crip_temp,1)>0 THEN #找到此ip 
                                                    ##DISPLAY "crip_temp:",l_crip_temp.getLength()+1
                                                   # #DISPLAY "l_read_str:",l_read_str.getLength()
                                                    #LET l_host=l_read_str.substring(l_crip_temp.getLength()+1,l_read_str.getLength() )
                                                    #
                                                    ##DISPLAY "AA_l_host:",l_host
                                                    #LET l_host=cl_replace_str(l_host," ","") #FUN-C50060 add
                                                    #LET l_host=cl_replace_str(l_host,"\t","") #FUN-C50060 add
                                                    #LET l_host=l_host.trim()
                                                    #EXIT WHILE 
                                                 #END IF                              
                                             #END IF   #FUN-C90106 ADD        
                                             #IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
                                      #END WHILE                              
                                      #CALL lc_chin.close()                              
                              #END IF  #FUN-C70069 add-
                               #
                              ##DISPLAY "l_host:",l_host 
                              #LET l_greport=fgl_GETENV("WINGREPORT")  #FUN-C50060 add
                              ##DISPLAY "FINAL l_host:",l_host
                              #CALL fgl_report_configureDistributedProcessing(l_host,l_greport)  #FUN-C50060 add
                              ##CALL fgl_report_configureDistributedProcessing(l_host,"6405")
                     #
                            ##TQC-C40053 ADD-END
                               ##CALL fgl_report_configureDistributedProcessing("STDB30-CRS-29","6405")   #FUN-C40010 設定分散模式 #TQC-C40053 MARK
                        ##END IF                    
	                 ##No.FUN-C40010 -- END --
                     ##FUN-D10044 mark-(e)
		               LET handler = fgl_report_commitCurrentSettings()
                       IF (g_sendmail.getLength() > 0 AND g_mail_cnt >= g_sendmail.getLength()) OR g_sendmail.getLength() = 0 THEN
                          LET l_save = ''                               #No.FUN-C10009   
                          CALL cl_gre_history_save() RETURNING l_save   #No.FUN-C10009,判斷是否需留存歷史報表
                          IF(l_save = 'Y') THEN                         #須留存      
                              CALL cl_gre_history()
                          END IF
                       END IF
                    END IF
              END CASE #CASE ls_outputformat
            END IF   #IF (l_action = 'layout_edit') THEN #若按下按鈕  ##TQC-C40053 mark  COCO:先mark--- - 120517 janet add
        ELSE #FUN-C40010 # 
            CALL cl_err(ls_path,'azz-056',1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B70007
            EXIT PROGRAM -1
        END IF 
    END IF
    #CLOSE WINDOW cl_gre_w
    RETURN handler
END FUNCTION

##################################################
# Private Func..: TRUE
##################################################
PRIVATE FUNCTION cl_gre_b_fill()
    DEFINE li_cnt    LIKE type_file.num10
    #DEFINE l_tmpstr  STRING #No.FUN-B80097
    DEFINE l_sql     STRING #No.FUN-B80041
    DEFINE l_gdw06   LIKE gdw_file.gdw06  #FUN-D10109 行業別

    CALL g_gdw.clear()
    LET li_cnt = 1
    LET l_gdw06 = g_sma.sma124   #FUN-D10109 add
    

    #No.FUN-B80041 --start--
    #FUN-B80092 add gdw14,gdw15; FUN-C30127 add '', FUN-C30259 將gdw10改為gfs10與fgs_file做join
    #LET l_sql = "SELECT '',gfs03,gdw03,gdw09,gdw11,gdw12,gdw13,gdw14,gdw15,gdw02,gdw08", #FUN-CB0144 mark
    LET l_sql = "SELECT 'N',gfs03,gdw03,gdw09,gdw11,gdw12,gdw13,gdw14,gdw15,gdw02,gdw08", #FUN-CB0144 add
                "       ,gdw05,gdw04,gdw17 ",   #FUN-D10108
                " FROM gdw_file left join gfs_file on gdw08 = gfs01 AND gfs02='", g_lang, "'",
                " WHERE gdw01='",g_prog CLIPPED,"'",
                " AND gdw09 NOT LIKE '%_sub%'", #No.FUN-B80097
                " AND gdw06 ='",l_gdw06 CLIPPED ,"'",  #FUN-D10109 add
                " AND ((gdw04='default' AND gdw05='default')", #No.FUN-C30011
                " OR   (gdw04='", g_clas CLIPPED,"' AND gdw05='default')", #No.FUN-C30011 顯示符合權限的樣板
                " OR   (gdw04='default' AND gdw05='",g_user CLIPPED,"'))"  #No.FUN-C30011 顯示符合使用者的樣板
                
    IF NOT cl_null(g_template) THEN
        LET l_sql = l_sql," AND gdw02='",g_template CLIPPED,"'"
    END IF

    LET l_sql = l_sql," ORDER BY gdw03 DESC,gdw09" #No.FUN-B80097
    DECLARE cl_gdw_cs CURSOR FROM l_sql
    #DECLARE cl_gdw_cs CURSOR FOR
        #SELECT UNIQUE gdw09,gdw03,gdw10,gdw11,gdw12,gdw13 FROM gdw_file
        #WHERE gdw01=g_prog
        #ORDER BY gdw09,gdw03
    #No.FUN-B80041 --end--

    FOREACH cl_gdw_cs INTO g_gdw[li_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #No.FUN-B80097 --start--
        #LET l_tmpstr = g_gdw[li_cnt].gdw09
        #IF l_tmpstr.getIndexOf("_sub",1) > 0 THEN
        #    CALL g_gdw.deleteElement(li_cnt)
        #    CONTINUE FOREACH
        #END IF
        #No.FUN-B80097 --end--
        IF cl_null(g_gdw[li_cnt].gdw17) THEN LET g_gdw[li_cnt].gdw17='N' END IF  #FUN-D10108
        IF li_cnt=1 THEN LET g_gdw[li_cnt].pick ='Y' END  IF  #FUN-CB0144 add
        LET li_cnt = li_cnt + 1
    END FOREACH

    ##FUN-D10109 add-(s)
    IF g_gdw[1].gdw09 IS NULL THEN  #沒有行業別的就抓std
        CALL g_gdw.clear()
        LET li_cnt = 1
        LET l_gdw06='std'
        LET l_sql = ""
        LET l_sql = "SELECT 'N',gfs03,gdw03,gdw09,gdw11,gdw12,gdw13,gdw14,gdw15,gdw02,gdw08",
                    "       ,gdw05,gdw04,gdw17 ",   #FUN-D10108 
                    " FROM gdw_file left join gfs_file on gdw08 = gfs01 AND gfs02='", g_lang, "'",
                    " WHERE gdw01='",g_prog CLIPPED,"'",
                    " AND gdw09 NOT LIKE '%_sub%'", 
                    " AND gdw06 ='",l_gdw06 CLIPPED ,"'",  
                    " AND ((gdw04='default' AND gdw05='default')", 
                    " OR   (gdw04='", g_clas CLIPPED,"' AND gdw05='default')", 
                    " OR   (gdw04='default' AND gdw05='",g_user CLIPPED,"'))"  
                    
        IF NOT cl_null(g_template) THEN
            LET l_sql = l_sql," AND gdw02='",g_template CLIPPED,"'"
        END IF

        LET l_sql = l_sql," ORDER BY gdw03 DESC,gdw09" 
        DECLARE cl_gdw_cs1 CURSOR FROM l_sql

        FOREACH cl_gdw_cs1 INTO g_gdw[li_cnt].*
            IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            IF cl_null(g_gdw[li_cnt].gdw17) THEN LET g_gdw[li_cnt].gdw17='N' END IF  #FUN-D10108
            IF li_cnt=1 THEN LET g_gdw[li_cnt].pick ='Y' END  IF  
            LET li_cnt = li_cnt + 1
        END FOREACH    
    END IF 
    ##FUN-D10109 add-(e)
    CALL g_gdw.deleteElement(li_cnt)
    LET g_rec_b = li_cnt - 1

   #FUN-D10108 依優先序重新排序陣列內容--(S)
    CALL cl_gre_b_fill_sort()
   #FUN-D10108 依優先序重新排序陣列內容--(E)

END FUNCTION

##################################################
# Library name...: cl_gre_init_pageheader
# Descriptions...: 將GR公用變數從資料庫讀出
# Input parameter: void
# Return code....: none
# Usage..........: CALL cl_gre_init_pageheader()
##################################################
FUNCTION cl_gre_init_pageheader()
    DEFINE l_azp02      LIKE azp_file.azp02
    DEFINE l_adr_lbl    LIKE gaq_file.gaq03
    DEFINE l_tel_lbl    LIKE gaq_file.gaq03
    DEFINE l_fax_lbl    LIKE gaq_file.gaq03
    DEFINE l_zo041      LIKE zo_file.zo041
    DEFINE l_zo042      LIKE zo_file.zo042
    DEFINE lc_plant     STRING               #FUN-D40013 add

    SELECT zo02,zo041,zo042,zo05,zo09
        INTO g_company,l_zo041,l_zo042,g_grPageHeader.co_tel,g_grPageHeader.co_fax
        FROM zo_file WHERE zo01 = g_rlang

    #LET g_grPageHeader.co_adr = l_zo041,"\n",l_zo042
    LET g_grPageHeader.co_adr = l_zo041 CLIPPED

    SELECT aza24 INTO g_grPageHeader.logoPos FROM aza_file
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant
    #LET g_grPageHeader.title1 = g_company CLIPPED,"[",g_plant CLIPPED,":",l_azp02 CLIPPED,"]" #FUN-D40013 mark
    IF g_aza.aza124="Y" THEN
       LET lc_plant="[", g_plant CLIPPED,":",l_azp02 CLIPPED, "]"
    ELSE
       LET lc_plant=""
    END IF
    LET g_grPageHeader.title1 = g_company CLIPPED,lc_plant CLIPPED #FUN-D40013 add
    #LET g_grPageHeader.title2 = cl_get_progdesc(g_prog,g_rlang) #FUN-D40008 mark
    LET g_grPageHeader.title2 = cl_get_reporttitle(g_prog,g_rlang)  #FUN-D40008 add
    LET g_grPageHeader.logo = FGL_GETENV("FGLASIP") || "/tiptop/pic/pdf_logo_",g_dbs CLIPPED,g_rlang CLIPPED,".jpg"
    SELECT gaq03 INTO l_adr_lbl FROM gaq_file WHERE gaq01 = 'zo041' AND gaq02 = g_lang
    SELECT gaq03 INTO l_tel_lbl FROM gaq_file WHERE gaq01 = 'zo05' AND gaq02 = g_lang
    SELECT gaq03 INTO l_fax_lbl FROM gaq_file WHERE gaq01 = 'zo09' AND gaq02 = g_lang
    LET g_grPageHeader.title3 = l_adr_lbl||": "||g_grPageHeader.co_adr
    LET g_grPageHeader.title4 = l_tel_lbl||": "||g_grPageHeader.co_tel||" "||l_fax_lbl||": "||g_grPageHeader.co_fax
    LET g_grPageHeader.g_apr_loc = ''          #FUN-C30012 初始化簽核列印位置
    LET g_grPageHeader.g_apr_str = ''          #FUN-C30012 初始化簽核字串
    
    LET g_ptime = TIME  #FUN-B70118
    SELECT zx02 INTO g_user_name FROM zx_file WHERE zx01=g_user   #FUN-B70118
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_sampledata
# Descriptions...: 產生GR的Sample Data
# Input parameter: p_dir    存放目錄路徑
#                  p_gdw09  4rp檔名
# Return code....: om.SaxDocumentHandler    SAX文件處理器物件
# Usage..........:
##################################################
PRIVATE FUNCTION cl_gre_sampledata(p_dir ,p_gdw09)
   DEFINE handler         om.SaxDocumentHandler
   DEFINE p_gdw09         LIKE gdw_file.gdw09
   DEFINE p_dir           STRING
   DEFINE l_dir           STRING
   #DEFINE ls_temp         STRING   #no use
   DEFINE ls_filename     STRING

   # create dir
   LET l_dir = os.Path.join( p_dir, "sampledata")
   IF NOT os.Path.exists(l_dir) THEN     #預設一定有這個資料夾
      IF os.Path.mkdir(l_dir) THEN
         IF os.Path.chrwx(l_dir ,511) THEN
	    #開放權限
         END IF
      ELSE
         DISPLAY "Create folder ",l_dir," fails."
         RETURN NULL
      END IF
   END IF

   -- make 4rp
   LET ls_filename = cl_gre_make4rp(l_dir , p_gdw09)

   -- load the 4rp file
   IF NOT fgl_report_loadCurrentSettings(ls_filename) THEN
      DISPLAY "Load report error"
   ELSE
      CALL cl_gre_del4rp(ls_filename)
   END IF

   LET ls_filename = p_gdw09 , ".sampledata"
   LET ls_filename = os.Path.join( l_dir ,ls_filename)

   -- write to 4rp with empty data
   CALL fgl_report_selectDevice("SVG")
   CALL fgl_report_selectPreview(0)

   -- Generate an XML data file:
   IF g_gre_progress = 'Y' THEN
       CALL cl_progressing("processing sampledata...." )
   END IF
   LET handler = fgl_report_createProcessLevelDataFile(ls_filename)
   IF g_gre_progress = 'Y' THEN
       CALL cl_progressing("finish sampledata...." )
   END IF
   IF os.Path.chrwx(ls_filename ,511) THEN
      #開放權限
   END IF
   RETURN handler

END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_del4rp
# Descriptions...: 刪除4rp樣板檔
##################################################
PRIVATE FUNCTION cl_gre_del4rp(ls_filename)
   DEFINE ls_filename     STRING

   IF os.Path.exists(ls_filename) THEN
      IF NOT os.Path.delete(ls_filename) THEN
	 DISPLAY "Cannot delete" , ls_filename
      END IF
   END IF

END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_make4rp
# Descriptions...: 產生4rp樣板檔
# Input parameter: p_dir    存放目錄路徑
#                  p_gdw09  4rp檔名
# Return code....: STRING   4rp檔路徑
# Usage..........:
##################################################
PRIVATE FUNCTION cl_gre_make4rp(p_dir,p_gdw09)
   DEFINE p_dir           STRING
   DEFINE p_gdw09         LIKE gdw_file.gdw09
   DEFINE lc_channel      base.Channel
   DEFINE ls_filename     STRING
   DEFINE ls_rdd          STRING
   DEFINE ls_report_name  STRING
   DEFINE ls_temp         STRING


   -- build 4rp xml
   LET ls_filename = os.Path.join( p_dir, p_gdw09 || '.4rp')
   CALL cl_gre_del4rp(ls_filename)

   LET ls_rdd = p_gdw09 , ".rdd"
   LET ls_report_name = p_gdw09 , "_rep"

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile( ls_filename CLIPPED, "a" )
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
   CALL lc_channel.write("<report:Report xmlns:rtl=\"http://www.4js.com/2004/RTL\" xmlns:report=\"http://www.4js.com/2007/REPORT\" xmlns=\"http://www.4js.com/2004/PXML\" version=\"3.00\"> ")
   CALL lc_channel.write("<report:Settings RWPageWidth=\"a4width\" RWPageLength=\"a4length\" RWLeftMargin=\"1.3cm\" RWTopMargin=\"1.3cm\" RWRightMargin=\"1.3cm\" RWBottomMargin=\"1.3cm\"> ")
   CALL lc_channel.write("     <report:FormatList>       ")
   CALL lc_channel.write("        <report:Format-SVG/>   ")
   CALL lc_channel.write("        <report:Format-PDF/>   ")
   CALL lc_channel.write("        <report:Format-image/> ")
   CALL lc_channel.write("     </report:FormatList>      ")
   CALL lc_channel.write("</report:Settings>      ")
   LET ls_temp = "   <report:Data RWDataLocation=\"", ls_rdd ,
                         "\" RWFglReportName=\"" ,ls_report_name, "\"/>"
   CALL lc_channel.write(ls_temp)
   CALL lc_channel.write("     <rtl:stylesheet> ")
   CALL lc_channel.write("         <PXML>       ")
   CALL lc_channel.write("            <rtl:match nameConstraint=\"Report\"> ")
   CALL lc_channel.write("               <MINIPAGE name=\"Page Root\" width=\"max\" length=\"max\"> ")
   CALL lc_channel.write("                    <rtl:match nameConstraint=\"Group\" minOccurs=\"0\" maxOccurs=\"unbounded\"> ")
   CALL lc_channel.write("                       <rtl:match nameConstraint=\"OnEveryRow\" minOccurs=\"0\" maxOccurs=\"unbounded\"/> ")
   CALL lc_channel.write("                    </rtl:match> ")
   CALL lc_channel.write("               </MINIPAGE> ")
   CALL lc_channel.write("            </rtl:match> ")
   CALL lc_channel.write("         </PXML>      ")
   CALL lc_channel.write("     </rtl:stylesheet> ")
   CALL lc_channel.write("</report:Report> ")
   CALL lc_channel.close()
   RETURN ls_filename

END FUNCTION

##################################################
# Library name...: cl_gre_close_report
# Descriptions...: 關閉GR報表詢問視窗
# Input parameter: void
# Return code....: none
# Usage..........: CALL cl_gre_close_report()
##################################################
FUNCTION cl_gre_close_report()
    DEFINE l_rootnode	om.DomNode
    DEFINE l_nodes	    om.NodeList
    DEFINE l_chmodname  STRING   #FUN-C60077
    DEFINE l_svgname    LIKE gcl_file.gcl06 #FUN-C80015 add    
    DEFINE l_sb         base.StringBuffer   #FUN-C80015 add
    DEFINE l_time       STRING              #FUN-C80015 add
    DEFINE l_time_str   LIKE gcl_file.gcl08 #FUN-C80015 add
    DEFINE l_date       LIKE gcl_file.gcl05  #FUN-C80015 add
    
    LET l_svgname=""                                 #FUN-C80015 add
    LET l_svgname=os.Path.basename(g_savefilename)   #FUN-C80015 add    
    #FUN-C60077 ADD -start
    LET l_chmodname =os.Path.join(FGL_GETENV("TEMPDIR"),os.Path.basename(g_savefilename))
    IF os.Path.exists(l_chmodname) THEN
      IF os.Path.chrwx(l_chmodname,511) THEN END IF  #修改歷史留檔svg權限 
      #DISPLAY "chmod 511"
            #FUN-C80015 ADD -start----------------------------   
            IF l_chmodname.getIndexOf("svg",1) <>0 THEN 
                #寫入歷史報表歷程檔        
                 LET l_date=g_today
                 LET l_time = CURRENT HOUR TO FRACTION(3)  #時間截記
                 LET l_sb = base.StringBuffer.create()
                 CALL l_sb.append(l_time)
                 CALL l_sb.replace(":","",0)
                 CALL l_sb.replace(" ","",0)
                 CALL l_sb.replace("-","",0)
                 CALL l_sb.replace(".","",0)
                 LET l_time = l_sb.toString()
                 LET l_time_str=l_time CLIPPED 
                 INSERT INTO gcl_file(gcl01, gcl02, gcl03, gcl04, gcl05, gcl06, gcl07,gcl08)    
                 VALUES (g_plant,g_prog,g_user,g_clas,l_date,l_svgname,'Y',l_time_str)
            END IF 
           #FUn-C80015 ADD -end---------------------------------   
    END IF 
    #FUN-C60077 ADD -end 
 
    LET g_savefilename = ""
    
    LET l_rootnode = ui.Interface.getRootNode()
    LET l_nodes = l_rootnode.selectByPath("//Window[@name=\"cl_gre_w\"]")
    IF l_nodes.getLength() >= 1 THEN
       CLOSE WINDOW cl_gre_w
    END IF
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_mail
# Descriptions...: 開啟GR mail視窗
# Input parameter: void
# Return code....: none
# Usage..........: CALL cl_gre_mail()
##################################################
PRIVATE FUNCTION cl_gre_mail()
   DEFINE   lr_mail        DYNAMIC ARRAY OF RECORD
              mlk03        LIKE mlk_file.mlk03,
              mlk05        LIKE mlk_file.mlk05,
              mlk04        LIKE mlk_file.mlk04,
              mlk07        LIKE mlk_file.mlk07
                           END RECORD
   DEFINE   lst_maillist   base.StringTokenizer
   DEFINE   ls_mail        STRING
   DEFINE   li_cnt         LIKE type_file.num5
   DEFINE   li_i           LIKE type_file.num5
   DEFINE   li_idx         LIKE type_file.num5

   #No.FUN-B80097 --start--
   #可能要+上跑CR或GR的判斷方式

   IF g_bgjob = "Y" THEN
      LET g_receiver_list = FGL_GETENV("MAIL_TO")
      LET g_cc_list = FGL_GETENV("MAIL_CC")
      LET g_bcc_list = FGL_GETENV("MAIL_BCC")
   ELSE
      CALL cl_gre_selmaillist() RETURNING g_receiver_list, g_cc_list, g_bcc_list
   END IF
   #No.FUN-B80097 --end--
   IF cl_null(g_receiver_list) AND cl_null(g_cc_list) AND cl_null(g_bcc_list) THEN
      RETURN
   END IF

   #拆解欲送信的GR format, 以便產生多次javamail寄送
   LET li_cnt = 1
   IF NOT cl_null(g_receiver_list) THEN
      LET lst_maillist = base.StringTokenizer.create(g_receiver_list, ";")
      WHILE lst_maillist.hasMoreTokens()
         LET ls_mail = lst_maillist.nextToken()
         IF NOT cl_null(ls_mail) THEN
            LET lr_mail[li_cnt].mlk03 = "1"
            CALL cl_splite(ls_mail) RETURNING lr_mail[li_cnt].mlk04,lr_mail[li_cnt].mlk05,lr_mail[li_cnt].mlk07
            LET li_cnt = li_cnt + 1
         END IF
      END WHILE
   END IF
   IF NOT cl_null(g_cc_list) THEN
      LET lst_maillist = base.StringTokenizer.create(g_cc_list, ";")
      WHILE lst_maillist.hasMoreTokens()
         LET ls_mail = lst_maillist.nextToken()
         IF NOT cl_null(ls_mail) THEN
            LET lr_mail[li_cnt].mlk03 = "2"
            CALL cl_splite(ls_mail) RETURNING lr_mail[li_cnt].mlk04,lr_mail[li_cnt].mlk05,lr_mail[li_cnt].mlk07
            LET li_cnt = li_cnt + 1
         END IF
      END WHILE
   END IF
   IF NOT cl_null(g_bcc_list) THEN
      LET lst_maillist = base.StringTokenizer.create(g_bcc_list, ";")
      WHILE lst_maillist.hasMoreTokens()
         LET ls_mail = lst_maillist.nextToken()
         IF NOT cl_null(ls_mail) THEN
            LET lr_mail[li_cnt].mlk03 = "3"
            CALL cl_splite(ls_mail) RETURNING lr_mail[li_cnt].mlk04,lr_mail[li_cnt].mlk05,lr_mail[li_cnt].mlk07
            LET li_cnt = li_cnt + 1
         END IF
      END WHILE
   END IF
   CALL g_sendmail.clear()
   FOR li_cnt = 1 TO lr_mail.getLength()
       LET li_idx = 0
       FOR li_i = 1 TO g_sendmail.getLength()
           IF lr_mail[li_cnt].mlk07 = g_sendmail[li_i].format THEN
              LET li_idx = li_i
              EXIT FOR
           END IF
       END FOR
       IF li_idx = 0 THEN
          LET li_idx = g_sendmail.getLength() + 1
          LET g_sendmail[li_idx].format = lr_mail[li_cnt].mlk07
       END IF
       CASE lr_mail[li_cnt].mlk03
          WHEN "1"
             LET g_sendmail[li_idx].receiver = g_sendmail[li_idx].receiver,
                                               lr_mail[li_cnt].mlk04 CLIPPED,":",
                                               lr_mail[li_cnt].mlk05 CLIPPED,";"
          WHEN "2"
             LET g_sendmail[li_idx].cc = g_sendmail[li_idx].cc,
                                         lr_mail[li_cnt].mlk04 CLIPPED,":",
                                         lr_mail[li_cnt].mlk05 CLIPPED,";"
          WHEN "3"
             LET g_sendmail[li_idx].bcc = g_sendmail[li_idx].bcc,
                                         lr_mail[li_cnt].mlk04 CLIPPED,":",
                                         lr_mail[li_cnt].mlk05 CLIPPED,";"
       END CASE
   END FOR

   IF g_sendmail.getLength() > 0 THEN
      LET g_mail_flag = TRUE
      LET g_mail_cnt = 0
   END IF
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_selmaillist
# Descriptions...: 設定GR mail收件者、副本、密件副本清單
# Input parameter: void
# Return code....: g_receiver_list  收件者清單
#                  g_cc_list        副本清單
#                  g_bcc_list       密件副本清單
# Usage..........: CALL cl_gre_selmaillist() RETURNING l_to_list, l_cc_list, l_bcc_list
##################################################
PRIVATE FUNCTION cl_gre_selmaillist()
   DEFINE   lr_mail        DYNAMIC ARRAY OF RECORD
              mlk03        LIKE mlk_file.mlk03,
              mlk05        LIKE mlk_file.mlk05,
              mlk04        LIKE mlk_file.mlk04,
              mlk07        LIKE mlk_file.mlk07,
              ready        LIKE type_file.chr1
                           END RECORD
   DEFINE   li_cnt         LIKE type_file.num5
   DEFINE   lst_maillist   base.StringTokenizer
   DEFINE   ls_mail        STRING
   DEFINE   l_ac           LIKE type_file.num5
   DEFINE   lc_gdw08        INTEGER #FUN-C30011
   DEFINE   l_zy06         LIKE zy_file.zy06 #FUN-C60029

   OPEN WINDOW cl_gre_maillist_w WITH FORM "lib/42f/cl_gre_maillist"
      ATTRIBUTES ( STYLE="greMaillistWindowType" )
   CALL ui.Interface.loadStyles(FGL_GETENV("TOPCONFIG")||os.Path.separator()||"4st"||os.Path.separator()||"mail.4st")
   CALL cl_ui_locale("cl_gre_maillist")
  #FUN-C60029 ----------start---
   CALL cl_gre_zy06() RETURNING l_zy06
   CALL cl_gre_format_combo(l_zy06,'mlk07','b')
  #FUN-C60029 -----------end----

   CALL lr_mail.clear()
   LET li_cnt = 1

   #若g_receiver_list, g_cc_list, g_bcc_list內有值, 則一起匯入列表
   IF NOT cl_null(g_receiver_list) THEN
      LET lst_maillist = base.StringTokenizer.create(g_receiver_list, ";")
      WHILE lst_maillist.hasMoreTokens()
         LET ls_mail = lst_maillist.nextToken()
         IF NOT cl_null(ls_mail) THEN
            LET lr_mail[li_cnt].mlk03 = "1"
            LET lr_mail[li_cnt].ready = "Y"
            CALL cl_splite(ls_mail) RETURNING lr_mail[li_cnt].mlk04,lr_mail[li_cnt].mlk05,lr_mail[li_cnt].mlk07
            IF cl_null(lr_mail[li_cnt].mlk07) THEN
               LET lr_mail[li_cnt].mlk07 = "1"
            END IF
            LET li_cnt = li_cnt + 1
         END IF
      END WHILE
   END IF
   IF NOT cl_null(g_cc_list) THEN
      LET lst_maillist = base.StringTokenizer.create(g_cc_list, ";")
      WHILE lst_maillist.hasMoreTokens()
         LET ls_mail = lst_maillist.nextToken()
         IF NOT cl_null(ls_mail) THEN
            LET lr_mail[li_cnt].mlk03 = "2"
            LET lr_mail[li_cnt].ready = "Y"
            CALL cl_splite(ls_mail) RETURNING lr_mail[li_cnt].mlk04,lr_mail[li_cnt].mlk05,lr_mail[li_cnt].mlk07
            IF cl_null(lr_mail[li_cnt].mlk07) THEN
               LET lr_mail[li_cnt].mlk07 = "1"
            END IF
            LET li_cnt = li_cnt + 1
         END IF
      END WHILE
   END IF
   
   IF NOT cl_null(g_bcc_list) THEN
      LET lst_maillist = base.StringTokenizer.create(g_bcc_list, ";")
      WHILE lst_maillist.hasMoreTokens()
         LET ls_mail = lst_maillist.nextToken()
         IF NOT cl_null(ls_mail) THEN
            LET lr_mail[li_cnt].mlk03 = "3"
            LET lr_mail[li_cnt].ready = "Y"
            CALL cl_splite(ls_mail) RETURNING lr_mail[li_cnt].mlk04,lr_mail[li_cnt].mlk05,lr_mail[li_cnt].mlk07
            IF cl_null(lr_mail[li_cnt].mlk07) THEN
               LET lr_mail[li_cnt].mlk07 = "1"
            END IF
            LET li_cnt = li_cnt + 1
         END IF
      END WHILE
   END IF

   #匯入設定檔內的receiver, cc, bcc
   IF lr_mail.getLength() == 0 THEN  #FUN-110609
      LET g_sql = "SELECT mlk03,mlk05,mlk04,mlk07,'Y' FROM mlk_file",
                  " WHERE mlk01 = '",g_prog CLIPPED,"' ORDER BY mlk03"
      PREPARE maillist_pre FROM g_sql
      DECLARE maillist_curs CURSOR FOR maillist_pre

      LET li_cnt = lr_mail.getLength() + 1
      FOREACH maillist_curs INTO lr_mail[li_cnt].*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET li_cnt = li_cnt + 1
      END FOREACH
      CALL lr_mail.deleteElement(li_cnt)
   END IF   #FUN-110609

   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT ARRAY lr_mail FROM s_maillist.*
         ATTRIBUTES(COUNT=lr_mail.getLength(), MAXCOUNT=g_max_rec,
                    INSERT ROW=FALSE, DELETE ROW=FALSE, APPEND ROW=TRUE,
                    WITHOUT DEFAULTS)
         BEFORE ROW
            LET l_ac = DIALOG.getCurrentRow("s_maillist")

         BEFORE INSERT
            INITIALIZE lr_mail[l_ac].* TO NULL
            LET lr_mail[l_ac].ready = "Y"
            LET lr_mail[l_ac].mlk07 = "1"
            NEXT FIELD mlk03

         AFTER FIELD mlk05
            IF NOT cl_null(lr_mail[l_ac].mlk05) THEN
               SELECT gen06 INTO lr_mail[l_ac].mlk04 FROM gen_file
                WHERE gen01 = lr_mail[l_ac].mlk05
               DISPLAY lr_mail[l_ac].mlk05 TO mlk05
            END IF
         ON ACTION controlp
            CASE
               WHEN INFIELD(mlk05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen_m"
                  LET g_qryparam.default1 = lr_mail[l_ac].mlk05
                  LET g_qryparam.default2 = lr_mail[l_ac].mlk04
                  CALL cl_create_qry() RETURNING lr_mail[l_ac].mlk05, lr_mail[l_ac].mlk04
                  DISPLAY BY NAME lr_mail[l_ac].mlk05, lr_mail[l_ac].mlk04
            END CASE
      END INPUT
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
          
      ON ACTION send
         ACCEPT DIALOG
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG
   END DIALOG

   CLOSE WINDOW cl_gre_maillist_w

   LET g_receiver_list = NULL
   LET g_cc_list = NULL
   LET g_bcc_list = NULL

   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   ELSE
      FOR li_cnt = 1 TO lr_mail.getLength()
          IF cl_null(lr_mail[li_cnt].ready) OR lr_mail[li_cnt].ready = "N" THEN
             CONTINUE FOR
          END IF
          IF cl_null(lr_mail[li_cnt].mlk04) OR cl_null(lr_mail[li_cnt].mlk07) THEN
             CONTINUE FOR
          END IF
          CASE lr_mail[li_cnt].mlk03
             WHEN "1"
                LET g_receiver_list = g_receiver_list,
                                      lr_mail[li_cnt].mlk04 CLIPPED,":",
                                      lr_mail[li_cnt].mlk05 CLIPPED,":",
                                      lr_mail[li_cnt].mlk07 CLIPPED,";"
             WHEN "2"
                LET g_cc_list = g_cc_list,
                                lr_mail[li_cnt].mlk04 CLIPPED,":",
                                lr_mail[li_cnt].mlk05 CLIPPED,":",
                                lr_mail[li_cnt].mlk07 CLIPPED,";"
             WHEN "3"
                LET g_bcc_list = g_bcc_list,
                                 lr_mail[li_cnt].mlk04 CLIPPED,":",
                                 lr_mail[li_cnt].mlk05 CLIPPED,":",
                                 lr_mail[li_cnt].mlk07 CLIPPED,";"
          END CASE
      END FOR
   END IF

   RETURN g_receiver_list, g_cc_list, g_bcc_list
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_javamail_prepare
# Descriptions...: GR mail的準備動作
# Input parameter:
# Return code....:
# Usage..........:
##################################################
PRIVATE FUNCTION cl_gre_javamail_prepare(pi_mail_idx)
   DEFINE   pi_mail_idx       LIKE type_file.num5
   DEFINE   lc_gaz03          LIKE gaz_file.gaz03
   DEFINE   lc_gaz06          LIKE gaz_file.gaz06  #TQC-C20476 ADD
   DEFINE   li_i              LIKE type_file.num5
   DEFINE   ls_para           STRING
   DEFINE   ls_context        STRING
   DEFINE   ls_pid            STRING
   DEFINE   ls_context_file,ls_context_file1   STRING #TQC-C40053 add ls_context_file1
   DEFINE   ls_cmd            STRING
   DEFINE   l_xml_str         STRING  #TQC-C40053 傳給p_gr_javamail的參數
   DEFINE   l_time            STRING  # TQC-C40053 add
   
   IF cl_null(g_sendmail[pi_mail_idx].receiver) AND
      cl_null(g_sendmail[pi_mail_idx].cc)       AND
      cl_null(g_sendmail[pi_mail_idx].bcc)      THEN
      RETURN
   END IF

   LET lc_gaz03 = cl_get_progdesc(g_prog,g_lang)
   LET g_xml.recipient = g_sendmail[pi_mail_idx].receiver
   LET g_xml.cc        = g_sendmail[pi_mail_idx].cc
   LET g_xml.bcc       = g_sendmail[pi_mail_idx].bcc
   LET g_xml.subject   = cl_getmsg("lib-227",g_lang) CLIPPED," : ", lc_gaz03 CLIPPED, "\(", g_prog CLIPPED, "\) ",
                         cl_getmsg("lib-228",g_lang) CLIPPED," : ", g_company CLIPPED," ",
                         cl_getmsg("lib-229",g_lang) CLIPPED," : ", g_user CLIPPED," ",
                         cl_getmsg("lib-230",g_lang) CLIPPED," : ", g_today
   
   
   #FUN-110608 --start--
   #FUN-110608 marked --start--
   #CASE g_sendmail[pi_mail_idx].format
   #   WHEN "1" LET g_xml.attach = os.Path.join(FGL_GETENV("TEMPDIR"),"report.pdf")
   #   WHEN "2" LET g_xml.attach = os.Path.join(FGL_GETENV("TEMPDIR"),"report.xls")
   #   WHEN "3" LET g_xml.attach = os.Path.join(FGL_GETENV("TEMPDIR"),"report.xls")
   #   WHEN "4" LET g_xml.attach = os.Path.join(FGL_GETENV("TEMPDIR"),"report.html")
   #END CASE
   #FUN-110608 marked --end--

   CASE g_sendmail[pi_mail_idx].format   #add No.FUN-110608
       WHEN "1" LET g_xml.attach = g_mail_attach,".pdf"
       WHEN "2" LET g_xml.attach = g_mail_attach,".xls"
       WHEN "3" LET g_xml.attach = g_mail_attach,".xls"
       WHEN "4" LET g_xml.attach = g_mail_attach,".xlsx"   #No.FUN-C30255
       WHEN "5" LET g_xml.attach = g_mail_attach,".xlsx"   #No.FUN-C30255
       WHEN "6" LET g_xml.attach = g_mail_attach,".rtf"    #No.FUN-C30255
       WHEN "7" LET g_xml.attach = g_mail_attach,".html"
       OTHERWISE LET g_xml.attach = g_mail_attach,".pdf"   #No.FUN-B80097 格式預設為PDF
   END CASE 
   #FUN-110608 --end--
   #DISPLAY "for test g_xml.attach:",g_xml.attach
    #DISPLAY "g_mail_attach:",g_mail_attach

   FOR li_i = 1 TO NUM_ARGS()
       LET ls_para = ls_para," '",ARG_VAL(li_i),"'"
   END FOR

   #TQC-C40053 add ---start
   LET l_time = CURRENT HOUR TO FRACTION(5)   
   LET l_time = cl_replace_str(EXTEND(l_time, HOUR TO FRACTION(5)), ":", "")
   LET l_time = cl_replace_str(l_time, ".", "_")
  # DISPLAY "l_time:",l_time
   #TQC-C40053 add ---end 
   LET ls_pid= FGL_GETPID(),l_time #TQC-C40053 add  120430 add l_time
  
   
   #LET ls_pid= FGL_GETPID() #TQC-C40053 add 
   #DISPLAY "##ls_pid:",ls_pid
   LET ls_para = cl_replace_str(ls_para,"'","\"")
   LET ls_context = cl_gre_gen_context(ls_para)
   #janet add new
   IF os.Path.exists(ls_context) THEN
       LET ls_pid= FGL_GETPID(),l_time #TQC-C40053 add   l_time
       #DISPLAY "new ls_pid:",ls_pid
   END IF 
   #janet add new 
   LET ls_context_file = FGL_GETENV("TEMPDIR"),os.Path.separator(),"report_context_",ls_pid.trim(),".txt"
   #DISPLAY "ls_context_file:",ls_context_file
   LET ls_cmd = "echo '", ls_context,"' > ",ls_context_file
   RUN ls_cmd
   LET g_xml.body = ls_context_file
   # TQC-C40053 ADD-START ----
   LET l_xml_str="" 
   LET l_xml_str=l_xml_str,g_xml.attach,"|",g_xml.bcc ,"|",g_xml.body,"|",g_xml.cc,
       "|",g_xml.file,"|",g_xml.mailserver,"|",g_xml.passwd,"|",g_xml.recipient,
       "|",g_xml.sender,"|",g_xml.serverport,"|",g_xml.subject,"|",g_xml.user,
       "|"
    #TQC-C40053 add--start
   LET ls_context_file1 = FGL_GETENV("TEMPDIR"),os.Path.separator(),ls_pid.trim(),".txt"
   LET ls_cmd=""
   LET ls_cmd = "echo '", l_xml_str,"' > ",ls_context_file1
   RUN ls_cmd 
   #TQC-C40053 add--end 
      LET ls_cmd=""
      LET ls_cmd = "p_gr_javamail '",ls_context_file1 CLIPPED ,"' '",g_prog,"'"
     # DISPLAY "ls_cmd:",ls_cmd
     # CALL cl_cmdrun(ls_cmd) #FUN-C70120 mark
      CALL cl_cmdrun_wait(ls_cmd)   #FUN-C70120 add

   # TQC-C40053 ADD-END------
   #SLEEP 3 #TQC-C40053 mark
   #CALL cl_jmail() #TQC-C40053 mark
   #TQC-C40053 MARK
   #IF os.Path.delete(ls_context_file CLIPPED) THEN
   #END IF
   #TQC-C40053 MARK
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_gen_context
# Descriptions...: 設定GR mail的郵件本文
# Input parameter:
# Return code....:
# Usage..........:
##################################################
PRIVATE FUNCTION cl_gre_gen_context(ps_para)
   DEFINE ps_para     STRING
   DEFINE ls_context  STRING

   #FUN-C30109 MARK---START
   #LET ls_context = "<html><head><title>jmail</title></head>\n<body>\n",
                    #"<table style=\"border: black 1px solid; border-collapse: collapse\">\n",
                    #"<tr><td colspan=\"2\" style=\"font-weight: bold; font-size: 20px; color: white; background-color: #f08080; font-variant: normal\">",
                    #cl_getmsg("lib-282",g_lang) CLIPPED,"</td></tr>\n",
                    #"<tr><td style=\"width: 140px; color: white; background-color: #365f91\">",cl_getmsg("lib-227",g_lang) CLIPPED,
                    #"</td><td style=\"background-color: #A7BFDE\">",cl_get_progname(g_prog,g_lang),"\(",g_prog CLIPPED,"\)</td></tr>\n",
                    #"<tr><td style=\"color: white; background-color: #365f91\">",cl_getmsg("lib-229",g_lang) CLIPPED,
                    #"</td><td style=\"background-color: #dbe5f1\">" ,g_user CLIPPED,"</td></tr>\n",
                    #"<tr><td style=\"color: white; background-color: #365f91\">",cl_getmsg("lib-279",g_lang) CLIPPED,
                    #"</td><td style=\"background-color: #A7BFDE\">" ,TODAY," ",TIME,"</td></tr>\n",
                    #"<tr><td style=\"color: white; background-color: #365f91\">",cl_getmsg("lib-280",g_lang) CLIPPED,
                    #"</td><td style=\"background-color: #dbe5f1\">" ,ps_para,"</td></tr>\n",
                    #"<tr><td style=\"color: white; background-color: #365f91\">",cl_getmsg("lib-281",g_lang) CLIPPED,
                    #"</td><td style=\"background-color: #A7BFDE\">"
     #FUN-C30109 MARK---END
#FUN-C30109 ADD-START--------------
   LET ls_context = "<html><head><title>jmail</title></head>\n<body>\n",
                    "<table style=\"border: black 1px solid; border-collapse: collapse\">\n",
                    "<tr><td colspan=\"2\" style=\"font-weight: bold; font-size: 20px; color: white; background-color: #f08080; font-variant: normal\">",
                    cl_getmsg("lib-282",g_lang) CLIPPED,"</td></tr>\n",
                    "<tr><td style=\"width: 140px; color: white; background-color: #365f91\">",cl_getmsg("lib-227",g_lang) CLIPPED,
                    "</td><td style=\"background-color: #A7BFDE\">",cl_get_progname(g_prog,g_lang),"\(",g_prog CLIPPED,"\)</td></tr>\n",
                    "<tr><td style=\"color: white; background-color: #365f91\">",cl_getmsg("lib-229",g_lang) CLIPPED,
                    "</td><td style=\"background-color: #dbe5f1\">" ,g_user CLIPPED,"</td></tr>\n",
                    "<tr><td style=\"color: white; background-color: #365f91\">",cl_getmsg("lib-279",g_lang) CLIPPED,
                    "</td><td style=\"background-color: #A7BFDE\">" ,TODAY," ",TIME,"</td></tr>\n"
                    IF g_bgjob!=1 AND NOT cl_null(ps_para) THEN
                       LET ls_context=ls_context ,"<tr><td style=\"color: white; background-color: #365f91\">",cl_getmsg("lib-280",g_lang) CLIPPED,
                       "</td><td style=\"background-color: #dbe5f1\">" ,ps_para,"</td></tr>\n"
                    END IF 
 
                    LET ls_context=ls_context ,"<tr><td style=\"color: white; background-color: #365f91\">",cl_getmsg("lib-281",g_lang) CLIPPED,
                                               "</td><td style=\"background-color: #A7BFDE\">"


#FUN-C30109 ADD-END-----------------

    #TQC-C40053 mark                
   #IF NOT os.Path.exists(g_xml.attach) THEN
      #LET ls_context = ls_context,cl_getmsg("lib-216",g_lang),"</td></tr>\n"
   #ELSE
      #LET ls_context = ls_context,cl_getmsg("lib-284",g_lang),"</td></tr>\n"
   #END IF
   #TQC-C40053 mark   
   #LET ls_context = ls_context,"{result}</td></tr>\n" #TQC-C40053 janet 0423 add
   #DISPLAY "ls_context:",ls_context 
   LET ls_context = ls_context,"${result}</td></tr>\n" #TQC-C40053 add  原本
   LET ls_context = ls_context,"</table>\n</body>\n</html>\n"
   RETURN ls_context
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_savename
# Descriptions...: 取得GR歷史報表的檔案路徑,且根據檔案存在與否以及產生時間，選擇欲覆蓋檔案
# Input parameter: p_code 傳入程式代號
# Return code....: l_name 返回檔案完整名稱
# Usage..........:
##################################################
PRIVATE FUNCTION cl_gre_savename(p_code,p_gdw08)  #FUN-C80015 add ,p_gdw08
   DEFINE  p_code              LIKE zz_file.zz01,
           l_name              LIKE type_file.chr100,    #No.FUN-C10009 檔案名稱長度從20改至100
           l_temp_path         STRING,    #No.FUN-C10009 用來儲存路徑及檔案名稱
           l_time_ori          STRING,    #No.FUN-C10009 儲存檔案最後修改時間
           l_time_yymmdd       STRING,    #No.FUN-C10009 儲存修改時間之年月日
           l_time_hhmmss       STRING,    #No.FUN-C10009 儲存修改時間之時分秒
           l_oldest            SMALLINT   #No.FUN-C10009 指出最早產生的檔案是第幾份 
           #l_buf              LIKE type_file.chr6,       #No.FUN-C10009
           #l_n                LIKE type_file.num5,       #No.FUN-C10009
           #l_n2               LIKE type_file.num5        #No.FUN-C10009 
   DEFINE  l_yymmdd_comp       DYNAMIC ARRAY OF INTEGER   #No.FUN-C10009 儲存年月日
   DEFINE l_gdy05  LIKE gdy_file.gdy05                                                 #FUN-C80015 add
   DEFINE  l_hhmmss_comp       DYNAMIC ARRAY OF INTEGER   #No.FUN-C10009 儲存時分秒
   DEFINE  i                   INTEGER    #No.FUN-C10009 FOR迴圈計數用 
   DEFINE  i_min               INTEGER    #No.FUN-C10009 FOR迴圈計數用 
   DEFINE  i_max               INTEGER    #No.FUN-C10009 FOR迴圈計數用 
   DEFINE  i_str               STRING     #儲存檔案目前份數,將整數轉為字串用
   #FUN-C80015 add start-----------
   DEFINE  l_filename          STRING
   DEFINE  l_gcw               RECORD LIKE gcw_file.*
   DEFINE  l_min,l_max         LIKE type_file.num5
   DEFINE  l_str               STRING
   DEFINE  l_item_name         STRING
   DEFINE  l_gdw               RECORD LIKE gdw_file.*
   DEFINE  l_zx02              LIKE zx_file.zx02
   DEFINE  l_zx04              LIKE zx_file.zx04
   DEFINE  l_gaz03             LIKE gaz_file.gaz03
   DEFINE  l_gaz06             LIKE gaz_file.gaz06
   DEFINE  p_gdw08             LIKE gdw_file.gdw08
   DEFINE  l_n,l_diff      LIKE type_file.num5
   DEFINE  l_time              LIKE type_file.chr8
   DEFINE  l_gcl               RECORD LIKE gcl_file.*
   DEFINE  l_sql               STRING 
   DEFINE  l_gcl2  RECORD LIKE gcl_file.*
   DEFINE  l_i                 LIKE type_file.num5
   #FUN-C80015 add end ------------------------------

#FUN-C80015 mark start-------------------(依p_gr_history與p_grw自訂檔名設定)   
#   #FUN-C10009 mark -START       
#   #SELECT zz16  INTO l_n
#     #FROM zz_FILE WHERE zz01 = p_code
#   #IF (l_n IS NULL OR l_n <0) THEN LET l_n=0 END IF
#   #LET l_n = l_n + 1
#   #IF l_n > 30000 THEN  LET l_n = 0  END IF
#   #UPDATE zz_file SET zz16 = l_n WHERE zz01=p_code
#   #LET l_buf = l_n USING "&&&&&&"
#   #IF cl_null(g_aza.aza49) THEN
#     #UPDATE aza_file set aza49='1'
#     #IF SQLCA.sqlcode THEN
#        #CALL cl_err3("upd","aza_file","","",SQLCA.sqlcode,"","",0)
#        #RETURN NULL
#     #END IF
#     #LET g_aza.aza49 = '1'
#   #END IF
#   #FUN-C10009 mark -END
#   
#   CALL l_yymmdd_comp.clear()
#   CALL l_hhmmss_comp.clear()
#   LET l_oldest = ''
# 
#   IF g_aza.aza49 = '1' THEN   #00r-09r 留存份數為10份
#      #LET l_name = p_code CLIPPED, "_", g_user,"_0",l_buf[6,6],"r" #No.FUN-C10009
#      LET i_min = 0
#      LET i_max = 9
#
#      FOR i = i_min TO i_max   #從第00份開始至09份，留存份數共10份
#         LET i_str = i
#         LET l_name = g_plant, "_", p_code CLIPPED, "_", g_user,"_0"
#         LET l_name =  l_name CLIPPED, i_str, "r.svg"
#         LET l_temp_path = os.Path.join(FGL_GETENV("TEMPDIR"), l_name)
#         
#         IF NOT os.Path.exists(l_temp_path) THEN   #判斷檔案是否存在
#            RETURN l_name                          #檔名不存在代表可使用該檔名
#         ELSE
#            LET l_time_ori = os.Path.atime(l_temp_path)   #取得檔案最後存取時間
#            LET l_time_yymmdd = l_time_ori.getCharAt(3), l_time_ori.getCharAt(4), 
#                                l_time_ori.getCharAt(6), l_time_ori.getCharAt(7),
#                                l_time_ori.getCharAt(9), l_time_ori.getCharAt(10)
#            LET l_time_hhmmss = l_time_ori.getCharAt(12), l_time_ori.getCharAt(13), 
#                                l_time_ori.getCharAt(15), l_time_ori.getCharAt(16),
#                                l_time_ori.getCharAt(18), l_time_ori.getCharAt(19)
#            #陣列從[1]開始故i需+1                    
#            LET l_yymmdd_comp[i+1] = l_time_yymmdd   #將該份產生的年月日時間儲存至陣列
#            LET l_hhmmss_comp[i+1] = l_time_hhmmss   #將該份產生的時分秒時間儲存至陣列
#         END IF
#         
#         IF i_max+1 <= l_yymmdd_comp.getLength() THEN     
#            #找出最早產生的檔案是哪一個(開始)
#            #IF NOT (i == 0) THEN
#            LET l_oldest = 1
#            FOR i = 1 TO i_max 
#               #比較檔案時間年月日
#               IF l_yymmdd_comp[i+1] < l_yymmdd_comp[l_oldest] THEN
#                  LET l_oldest = i+1
#               END IF
#               #如果年月日相同，就需要比較時分秒
#               IF l_yymmdd_comp[i+1] = l_yymmdd_comp[l_oldest] THEN
#                  #比較檔案時間時分秒
#                  IF l_hhmmss_comp[i+1] < l_hhmmss_comp[l_oldest] THEN
#                     LET l_oldest = i+1
#                  END IF
#               END IF
#            END FOR
#            LET l_oldest = l_oldest - 1
#            LET i_str = l_oldest
#            LET l_name = g_plant, "_", p_code CLIPPED, "_", g_user,"_0", i_str, "r.svg"
#            RETURN l_name
#         END IF
#      END FOR
#   ELSE
#      CASE g_aza.aza49   #根據留存份數來設定FOR迴圈的起始和結束值
#         WHEN '2'   #00r-19r,20份
#         LET i_min = 0
#         LET i_max = 19
#         WHEN '3'   #01r-29r,30份
#         LET i_min = 0
#         LET i_max = 29
#         WHEN '4'   #01r-39r,40份
#         LET i_min = 0
#         LET i_max = 39
#         WHEN '5'   #01r-49r,50份
#         LET i_min = 0
#         LET i_max = 49         
#      END CASE
#
#      FOR i = i_min TO i_max
#         LET i_str = i
#         IF i<10 THEN   #i<10時,第2位數須加上0,例如00,01,02,至09
#            LET l_name = g_plant, "_", p_code CLIPPED, "_", g_user,"_0" #組合檔名
#         ELSE
#            LET l_name = g_plant, "_", p_code CLIPPED, "_", g_user,"_"  #組合檔名         
#         END IF
#         LET l_name =  l_name CLIPPED, i_str, "r.svg"                   #組合檔名
#         LET l_temp_path = os.Path.join(FGL_GETENV("TEMPDIR"), l_name)  #加上路徑

#         #檢查路徑及檔名是否已有相同檔案名稱,若沒有可直接產生檔案,否則便需要比較檔案時間
#         IF NOT os.Path.exists(l_temp_path) THEN
#            RETURN l_name
#         ELSE
#            LET l_time_ori = os.Path.atime(l_temp_path)   #取得檔案時間
#            LET l_time_yymmdd = l_time_ori.getCharAt(3), l_time_ori.getCharAt(4), 
#                                l_time_ori.getCharAt(6), l_time_ori.getCharAt(7),
#                                l_time_ori.getCharAt(9), l_time_ori.getCharAt(10)
#            LET l_time_hhmmss = l_time_ori.getCharAt(12), l_time_ori.getCharAt(13), 
#                                l_time_ori.getCharAt(15), l_time_ori.getCharAt(16),
#                                l_time_ori.getCharAt(18), l_time_ori.getCharAt(19)
#            LET l_yymmdd_comp[i+1] = l_time_yymmdd
#            LET l_hhmmss_comp[i+1] = l_time_hhmmss
#         END IF
#         
#         IF i_max+1 <= l_yymmdd_comp.getLength() THEN     
#            #找出最早產生的檔案是哪一個(開始)
#            #IF NOT (i == 0) THEN
#            LET l_oldest = 1
#            FOR i = 1 TO i_max 
#            #比較檔案時間年月日
#               IF l_yymmdd_comp[i+1] < l_yymmdd_comp[l_oldest] THEN
#                  LET l_oldest = i+1
#               END IF
#               #如果年月日相同，就需要比較時分秒
#               IF l_yymmdd_comp[i+1] = l_yymmdd_comp[l_oldest] THEN
#                  #比較檔案時間時分秒
#                  IF l_hhmmss_comp[i+1] < l_hhmmss_comp[l_oldest] THEN
#                     LET l_oldest = i+1
#                  END IF
#               END IF
#            END FOR
#            LET l_oldest = l_oldest - 1   #矩陣從1開始,但檔名從00r開始算故減一
#            LET i_str = l_oldest          #轉字串 
#            LET l_name = g_plant, "_", p_code CLIPPED, "_", g_user,"_0", i_str, "r.svg"
#            RETURN l_name
#         END IF
#      END FOR      
#      #LET l_buf = l_n2 USING "&&&&&&"   FUN-C10009 mark
#      #LET l_name = p_code CLIPPED, "_",l_buf[5,6],"r"   FUN-C10009 mark
#   END IF
#   #LET l_name =  l_name, ".svg"  FUN-C10009 mark
#   RETURN l_name
   #先判斷是否維護 p_gr_history，取得留存份數  
   #FUN-C80015 ADD----START--------   
    CALL cl_gre_chk_gdy05() RETURNING l_gdy05
    IF NOT cl_null(l_gdy05) THEN
       LET i_min = 0
       CASE l_gdy05
         WHEN "0"  #依系統設定
            CASE g_aza.aza49
              WHEN "1" LET l_max = 10
              WHEN "2" LET l_max = 20
              WHEN "3" LET l_max = 30
              WHEN "4" LET l_max = 40
              WHEN "5" LET l_max = 50
            END CASE
         WHEN "1"  #00~09 
            LET l_max = 10
         WHEN "2"  #00~19 
            LET l_max = 20
         WHEN "3"  #00~29 
            LET l_max = 30
         WHEN "4"  #00~39 
            LET l_max = 40
         WHEN "5"  #00~49 
            LET l_max = 50
       END CASE
      #檢查是否有自訂命名，若無則依標準命名
       SELECT * INTO l_gdw.* FROM gdw_file 
        WHERE gdw08 = p_gdw08   
       INITIALIZE l_gcw.* TO NULL 
       SELECT * INTO l_gcw.* FROM gcw_file 
        WHERE gcw01=l_gdw.gdw01
          AND gcw02=l_gdw.gdw02
          AND gcw03=l_gdw.gdw04
          AND gcw04=l_gdw.gdw05
       LET l_sql = "SELECT * FROM gcl_file ",
                   " WHERE gcl01 = '",g_plant,"'",
                   "   AND gcl02 = '",g_prog,"'",
                   "   AND gcl03 = '",g_user,"'",
                   "   AND gcl07 = 'Y'",
                   " ORDER BY gcl05 ,gcl08 "
       PREPARE gcl_pr1 FROM l_sql
       DECLARE gcl_cur1 CURSOR FOR gcl_pr1
       LET l_sql = "SELECT * FROM gcl_file ",
            " WHERE gcl01 = '",g_plant,"'",
            "   AND gcl02 = '",g_prog,"'",
            "   AND gcl03 = '",g_user,"'",
            "   AND gcl07 = 'Y'",
            " ORDER BY gcl05 DESC ,gcl08 DESC"
       PREPARE gcl_pr2 FROM l_sql
       DECLARE gcl_cur2 CURSOR FOR gcl_pr2
      #找目前有效的歷史報表有幾筆
       SELECT COUNT(*) INTO l_n FROM gcl_file
          WHERE gcl01 = g_plant
            AND gcl02 = g_prog
            AND gcl03 = g_user
            AND gcl07 = 'Y'

      #有設定自訂檔名(gcw) 報表檔名第一段~第六段
       IF (NOT cl_null(l_gcw.gcw05)) OR (NOT cl_null(l_gcw.gcw06)) OR (NOT cl_null(l_gcw.gcw07)) OR (NOT cl_null(l_gcw.gcw08)) OR
          (NOT cl_null(l_gcw.gcw09)) OR (NOT cl_null(l_gcw.gcw10)) THEN
          SELECT zx02,zx04 INTO l_zx02,l_zx04 FROM zx_file WHERE zx01 = g_user   #使用者名稱/權限類別
          SELECT gaz03,gaz06 INTO l_gaz03,l_gaz06 FROM gaz_file   #多語系程式名稱/報表抬頭
           WHERE gaz01=g_prog AND gaz02=g_rlang
          IF cl_null(l_gaz06) THEN
             LET l_gaz06 = l_gaz03 CLIPPED
          END IF 
          LET l_time=TIME
          LET l_item_name = p_code CLIPPED,"|",l_gaz06 CLIPPED,"|",g_plant CLIPPED,"|",g_dbs CLIPPED,"|",g_user CLIPPED,"|",l_zx02 CLIPPED,"|",g_pdate CLIPPED,"|",l_time CLIPPED       
              
          CALL cl_prt_filename(l_item_name,l_gcw.gcw05) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw06) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw07) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw08) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw09) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw10) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          #刪除最後一個分隔符號
          LET l_str = l_filename CLIPPED
          LET l_str = l_str.substring(1,l_str.getLength()-1) CLIPPED
          LET l_filename = l_str CLIPPED
       ELSE  #不自訂命名，依標準命名
          LET l_filename = g_plant, "_", p_code CLIPPED, "_", g_user   #組合檔名     
       END IF
       IF l_n >= l_max THEN #數量超出最大留存量
          LET l_diff = l_n - l_max + 1
          LET l_i = 0
         #把超出數量的歷史報表檔案變更為無效
          FOREACH gcl_cur1 INTO l_gcl.*
              LET l_i = l_i + 1
              IF l_i <= l_diff THEN
                 UPDATE gcl_file SET gcl07 = 'N'
                  WHERE gcl01 = l_gcl.gcl01
                    AND gcl02 = l_gcl.gcl02
                    AND gcl03 = l_gcl.gcl03
                    AND gcl05 = l_gcl.gcl05
                    AND gcl08 = l_gcl.gcl08
              END IF
          END FOREACH
         #取最後一筆的流水號
          IF LENGTH(l_gcl.gcl06) > 6 THEN
             LET i_str = l_gcl.gcl06[LENGTH(l_gcl.gcl06)-6,LENGTH(l_gcl.gcl06)-5] #取xxr.svg的xx
             LET i_str = (i_str + 1 ) USING '&&'
             IF i_str >= l_max THEN LET i_str = '00' END IF                
          ELSE
             LET i_str = '00'
          END IF
          LET l_filename = l_filename,"_",i_str, "r.svg"
       ELSE
          IF l_n = 0 THEN
             LET l_filename = l_filename CLIPPED,"_00r.svg"
          ELSE
             FOREACH gcl_cur2 INTO l_gcl.*
                 EXIT FOREACH
             END FOREACH
             LET i_str = l_gcl.gcl06[LENGTH(l_gcl.gcl06)-6,LENGTH(l_gcl.gcl06)-5] #取xxr.svg的xx
             LET i_str = (i_str + 1 ) USING '&&'
             LET l_filename = l_filename,"_",i_str, "r.svg"
          END IF
       END IF
    ELSE
       RETURN l_filename
    END IF

    RETURN l_filename

#FUN-C80015 ADD--------------   -END--
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_history
# Descriptions...: 修改控制GR歷史報表產生的狀態碼
# Input parameter:
# Return code....:
# Usage..........:
##################################################
PRIVATE FUNCTION cl_gre_history()
    IF g_gre_times = 2 THEN
       LET g_save_flag ="S"
       LET g_gre_times = 0
    ELSE
       IF cl_null(g_savefilename) THEN
          LET g_save_flag ="Y"         #歷史報表每次查詢只產生一次
          LET g_gre_times = 2
       END IF
    END IF
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_zv
# Descriptions...: GR直接送印
# Input parameter: void
# Return code....: om.SaxDocumentHandler    SAX文件處理器物件
# Usage..........: LET l_handler = cl_gre_zv()
##################################################
PRIVATE FUNCTION cl_gre_zv()
    DEFINE l_zv         DYNAMIC ARRAY OF RECORD
           zv01         LIKE zv_file.zv01,
           zv02         LIKE zv_file.zv02,
           zv03         LIKE zv_file.zv03,
           zv05         LIKE zv_file.zv05,
           zv06         LIKE zv_file.zv06,
           zv07         LIKE zv_file.zv07,
           zv08         LIKE zv_file.zv08,
           zv09         LIKE zv_file.zv09,     #FUN-C70120 add 列印份數
           gdw03        LIKE gdw_file.gdw03,  #FUN-D10044 add 
           gdw08        LIKE gdw_file.gdw08,  #FUN-D10077 add 
           gdw14        LIKE gdw_file.gdw14,  #FUN-D10077 add 
           gdw15        LIKE gdw_file.gdw15   #FUN-D10077 add 
           END RECORD
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_index      DYNAMIC ARRAY OF LIKE type_file.num5
    DEFINE l_current    LIKE type_file.num5
    DEFINE l_handler    om.SaxDocumentHandler
    DEFINE lc_zz011     LIKE zz_file.zz011
    DEFINE ls_path      STRING
    DEFINE ls_dbpath    STRING
    #FUN-D10044 add (s)
    DEFINE ls_path_win  STRING 
    DEFINE l_crip_temp,l_crip,l_host        STRING    
    DEFINE l_greport                         STRING   
    DEFINE l_mid_dir                         STRING   
    DEFINE l_cmd,l_read_str STRING            
    DEFINE lc_chin       base.Channel         
    DEFINE lc_chout         base.Channel     
    DEFINE lr_host          DYNAMIC ARRAY OF STRING    
    DEFINE l_l ,i,l_set ,l_set1            LIKE type_file.num5 
    DEFINE l_tok_param         base.StringTokenizer          
    DEFINE l_num_arr           DYNAMIC ARRAY OF INTEGER    
    DEFINE ls_dir,l_template_dir       STRING 
    DEFINE l_gaz03            LIKE gaz_file.gaz03
    DEFINE l_gaz06            LIKE gaz_file.gaz06
    DEFINE l_str_gaz          STRING 
    #FUN-D10044 add(e)
    DEFINE ls_output       STRING   #FUN-D10135 add   
    
    WHENEVER ERROR CONTINUE

    DECLARE cl_gre_zv_curs CURSOR FOR SELECT zv01,zv02,zv03,zv05,zv06,zv07,zv08,zv09 #FUN-C70120 add zv09
    FROM zv_file WHERE zv01=g_prog
    AND ((zv02='default' AND zv05='default') OR zv02=g_user OR zv05=g_clas)
    #AND zvacti='Y' AND zv08='Y' ORDER BY zv02,zv05,zv06,zv03  #FUN-D10135 mark
    AND zvacti='Y' ORDER BY zv02,zv05,zv06,zv03   #FUN-D10135 add
    
    CALL l_zv.clear()
    LET l_i = 1
    FOREACH cl_gre_zv_curs INTO l_zv[l_i].*
        LET l_i = l_i + 1
    END FOREACH
    IF l_zv.getLength() >= 1 THEN
        CALL l_zv.deleteElement(l_i)
    END IF

    FOR l_i = 1 TO l_zv.getLength()
        CASE
            WHEN l_zv[l_i].zv02=g_user
                LET l_index[1] = l_i
            WHEN l_zv[l_i].zv05=g_clas
                LET l_index[2] = l_i
            WHEN l_zv[l_i].zv02='default' AND l_zv[l_i].zv05='default'
                LET l_index[3] = l_i
        END CASE
        
       #FUN-D10077 add---- (s)
        SELECT gdw03,gdw08,gdw14,gdw15
          INTO l_zv[l_i].gdw03,l_zv[l_i].gdw08,l_zv[l_i].gdw14,l_zv[l_i].gdw15 
          FROM gdw_file 
         WHERE gdw09= l_zv[l_i].zv06 
           AND gdw01= g_prog
       #FUN-D10077 add---- (e)
    END FOR

    FOR l_i = 1 TO l_index.getLength()
        IF l_index[l_i] IS NOT NULL THEN
            LET l_current = l_index[l_i]
            EXIT FOR
        END IF
    END FOR

    IF l_current >= 1 THEN
        #LET lc_gdw02 = g_gdw[l_ac].gdw02
        SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01 = g_prog
        #設定42s路徑
        LET ls_path = os.Path.join(FGL_GETENV(lc_zz011 CLIPPED),"4rp")
        LET ls_path = os.Path.join(ls_path.trim(),g_lang CLIPPED)
        LET ls_dbpath = FGL_GETENV("DBPATH"),os.Path.pathseparator(),ls_path
        CALL FGL_SETENV("FGLRESOURCEPATH",ls_dbpath)
        #設定4rp路徑
        LET ls_path = os.Path.join(ls_path,l_zv[l_current].zv06||".4rp")   

         #FUN-D10044 add -(s)
        #報表名稱抓法改為先抓gaz06,若gaz06沒值,再抓gaz03
        SELECT gaz03,gaz06 INTO l_gaz03,l_gaz06 FROM gaz_file
         WHERE gaz01=l_zv[l_current].zv01 AND gaz02=g_rlang
        IF cl_null(l_gaz06) THEN
           LET l_gaz06 = l_gaz03 CLIPPED
        END IF  
        LET l_str_gaz=l_gaz06,"(", l_zv[l_current].zv01,")"
        CALL fgl_report_setTitle(l_str_gaz)    #130109 add 匯出是SVG格式才執行此API
        CALL fgl_report_setSVGCompression(TRUE)   #130109 add 壓縮svg檔案
         #FUN-D10044 add -(e)

       #FUN-D10077 取得簽核資料 -- (s)
        CALL cl_gre_get_apr_loc(l_zv[l_current].gdw14,l_zv[l_current].gdw15)
           RETURNING g_grPageHeader.g_apr_loc   #簽核列印位置
        CALL cl_gr_make_apr(l_zv[l_current].gdw08)  
       #FUN-D10077 取得簽核資料 -- (e)
        IF fgl_report_loadCurrentSettings(ls_path) THEN    
            IF l_zv[l_current].zv03 MATCHES "[123456789]" THEN
               # Server 端直接送印
               #CALL fgl_report_configureSVGPreview("PrintOnDefaultPrinter")  ##121009 JANET FOR TEST add
               #FUN-D10077 直接送印方式調整----(s)
                CALL fgl_report_selectDevice("Printer")                    

                IF NOT cl_null(l_zv[l_current].zv07) THEN #若有指定印表機則CALL API，若無則自動預設系統印表機
                   CALL fgl_report_setPrinterName(l_zv[l_current].zv07) 
                END IF
                CALL fgl_report_selectPreview(FALSE) 

                CALL fgl_report_setSVGCopies(l_zv[l_current].zv09)
                #若為中一刀則加上這兩個API (s)
                IF cl_gre_chk_halfletter(ls_path) THEN
                   CALL fgl_report_setPrinterOrientationRequested("portrait") 
                   CALL fgl_report_configurePageSize("21.59cm","27.94cm")
                END IF
                #若為中一刀則加上這兩個API (e)
               #FUN-D10077 直接送印方式調整----(e)
            ELSE
                # Client 端直接送印
                IF l_zv[l_current].zv03 = "L" THEN
                    IF l_zv[l_current].zv08= "Y" THEN      #FUN-D10135 add
                       CALL fgl_report_configureSVGPreview("PrintOnNamedPrinter") 
                    #FUN-D10135 add -(s)
                    ELSE 
                       CALL fgl_report_configureSVGPreview("ShowPrintDialog") 
                    END IF 
                    #FUN-D10135 add -(e)
                    CALL fgl_report_setSVGCopies(l_zv[l_current].zv09) #FUN-C70120 add 列印份數
                    #CALL fgl_report_setSVGPrinterName(l_zv[l_current].zv07)
                   #FUN-D10077 直接送印方式調整----(s)
                    IF NOT cl_null(l_zv[l_current].zv07) THEN #若有指定印表機則CALL API，若無則自動預設系統印表機
                       CALL fgl_report_setSVGPrinterName(l_zv[l_current].zv07)
                    END IF
                    #若為中一刀則加上這兩個API (s)
                    IF cl_gre_chk_halfletter(ls_path) THEN
                       CALL fgl_report_setPrinterOrientationRequested("portrait") 
                       CALL fgl_report_configurePageSize("21.59cm","27.94cm")
                    END IF
                    #若為中一刀則加上這兩個API (e)
                   #FUN-D10077 直接送印方式調整----(e)
                #FUN-D10135 add -(s)
                ELSE 
                 CASE l_zv[l_current].zv03
                    WHEN "P"
                       LET ls_output = "PDF"
                    WHEN "X" #合併one page
                       LET ls_output = "XLS"
                       CALL fgl_report_configureXLSDevice(1,100000, true,true,true,true,TRUE)
                    WHEN "F" #分成多頁
                       LET ls_output = "XLS"
                    WHEN "B" #新增XLSX格式
                       LET ls_output = "XLSX"
                       CALL fgl_report_configureXLSXDevice(1,100000, true,true,true,true,TRUE)
                    WHEN "E" #新增XLSX格式
                       LET ls_output = "XLSX"
                    WHEN "D"                  
                        LET ls_output = "RTF" # 匯出WORD   
                        CALL fgl_report_setTitle(l_str_gaz)                      
                    WHEN "I"                  #
                       LET ls_output = "HTML"

                 END CASE

                     CALL fgl_report_selectDevice(ls_output)
                     LET li_preview = 1
                     CALL fgl_report_selectPreview(li_preview)                
                #FUN-D10135 add -(e)
                END IF
 
            END IF
        END IF  
             #FUN-D10044 add -(s)------------

             CALL cl_gre_setRemoteLocations(l_zv[l_current].zv01,l_zv[l_current].gdw03,l_zv[l_current].zv06)
             ##130130 janet mark-(S)
                 #LET ls_path_win = cl_gre_get_4rpdir(l_zv[l_current].zv01,l_zv[l_current].gdw03,"W") #No.FUN-B80097 
                       ##DISPLAY '1.ls_path_win:', ls_path_win
                        #
                       #LET ls_dir  = ls_path_win
                       #LET ls_path_win = os.Path.join(ls_path_win.trim(),g_lang CLIPPED)
#
                       #LET ls_path_win = os.Path.join(ls_path_win,l_zv[l_current].zv06||".4rp") #No.FUN-B80041
#
                          #IF l_zv[l_current].gdw03="Y" THEN #客製
                             #LET l_mid_dir=os.Path.basename( FGL_GETENV("CUST"))
                          #ELSE 
                             #LET l_mid_dir="tiptop"   #FUN-C60077 add
                            # #LET l_mid_dir=os.Path.basename( FGL_GETENV("TOP"))    #FUN-C60077 mark
                          #END IF
                           #LET l_template_dir = os.Path.join(FGL_GETENV("TEMPLATEDRIVE"),l_mid_dir), ls_path_win
#
                       #IF ((NOT cl_null(FGL_GETENV("TEMPLATEDRIVE"))) AND (NOT cl_null(FGL_GETENV("WINFGLPROFILE")))
                           #AND (NOT cl_null(FGL_GETENV("WINFGLDIR"))) AND (NOT cl_null(FGL_GETENV("WINGREDIR")))) THEN
#
                           #
                        #CALL fgl_report_configureRemoteLocations(l_template_dir,FGL_GETENV("WINFGLPROFILE"),    
                                                                  #FGL_GETENV("WINFGLDIR"),FGL_GETENV("WINGREDIR"))
                                                                    #
                       #ELSE
                          #CALL cl_err('','azz1201',1)
                          #CALL cl_used(g_prog,g_time,2) RETURNING g_time
                          #EXIT PROGRAM -1
                       #END IF
                       ##TQC-C40053 ADD-START
#
                         ##讀檔
                         #LET l_crip_temp=""
                         #LET l_crip_temp=fgl_getenv('CRIP')
                         #LET l_crip_temp=cl_replace_str(l_crip_temp,"http://","")
                         #LET l_set=l_crip_temp.getIndexOf("/",1) #抓出/位置                              
                         #LET l_crip_temp=l_crip_temp.subString(1,l_set-1) #抓出ip
                         ##FUN-C70069 add---start
                        ## DISPLAY "#l_cRIP_TEMP:",l_crip_temp
                              #LET l_tok_param = base.StringTokenizer.createExt(l_crip_temp,".","",TRUE)
                              #LET i=0
                              #CALL l_num_arr.clear()
                              #WHILE l_tok_param.hasMoreTokens()
                                 ##DISPLAY l_tok_table.nextToken()
                                 #LET i=i+1
                                 #LET l_num_arr[i] =l_tok_param.nextToken()  
                                ## DISPLAY i,"l_num_arr:",l_num_arr[i] 
                              #END WHILE
                              ##DISPLAY "EXIT WHILE I=",i
                              #IF i=3 AND l_num_arr[1] IS NULL AND l_num_arr[2] IS NULL AND l_num_arr[3] IS NULL   THEN
                                 #LET l_host=l_crip_temp  
                                ## DISPLAY "DNS:l_crip_temp:",l_crip_temp
                              #ELSE   
                                ## DISPLAY "IP:l_crip_temp:",l_crip_temp
                                 #LET l_cmd = "/etc/hosts"      
                                 ##DISPLAY l_cmd
                                 #LET lc_chin = base.Channel.create() #create new 物件
                                 #CALL lc_chin.openFile(l_cmd,"r") #開啟檔案
                                 #LET l_l=1
#
                                 #WHILE TRUE   
                                        #LET l_read_str =lc_chin.readLine() #整行讀入
                                        #LET l_read_str = l_read_str.trim()       # FUN-C90106 add
                                        #IF l_read_str.getCharAt(1) <> '#' THEN   # FUN-C90106 add
                                            #IF l_read_str.getIndexOf(l_crip_temp,1)>0 THEN #找到此ip 
                                               ##DISPLAY "crip_temp:",l_crip_temp.getLength()+1
                                              # #DISPLAY "l_read_str:",l_read_str.getLength()
                                               #LET l_host=l_read_str.substring(l_crip_temp.getLength()+1,l_read_str.getLength() )
                                               #
                                              # #DISPLAY "AA_l_host:",l_host
                                               #LET l_host=cl_replace_str(l_host," ","") #FUN-C50060 add
                                               #LET l_host=cl_replace_str(l_host,"\t","") #FUN-C50060 add
                                               #LET l_host=l_host.trim()
                                               #EXIT WHILE 
                                            #END IF 
                                        #END IF # FUN-C90106 add
                                        #IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
                                 #END WHILE                              
                                 #CALL lc_chin.close()
#
                              #END IF 
                             #LET l_greport=fgl_GETENV("WINGREPORT")  #FUN-C50060 add
                              #
                              #CALL fgl_report_configureDistributedProcessing(l_host,l_greport)  #FUN-C50060 add
                            ##130130 janet mark-(e)
             ##FUN-D10044 add -(e)-------------
            LET l_handler = fgl_report_commitCurrentSettings()

    END IF
    RETURN l_handler
END FUNCTION


#FUN-D10044 -(s)
##################################################
# Private Func..: TRUE
# Library name...: cl_gre_setRemoteLocations
# Descriptions...: set gr configureRemoteLocations
# Input parameter: ls_path_win,gdw01,gdw03,gdw09
# Return code....: void
# Usage..........: CALL cl_gre_setRemoteLocations()
##################################################
FUNCTION cl_gre_setRemoteLocations(l_gdw01,l_gdw03,l_gdw09)
DEFINE ls_path_win   STRING #WINDOW PATH
DEFINE l_gdw01       LIKE gdw_file.gdw01  #程式代號
DEFINE l_gdw03       LIKE gdw_file.gdw03  #客製否
DEFINE l_gdw09       LIKE gdw_file.gdw09  #樣板名稱
DEFINE ls_dir        STRING 
DEFINE l_template_dir STRING 
DEFINE l_drive_str    STRING             # 存fgl_getenv("TEMPLATEDRIVE")的字串
DEFINE l_cmd,l_read_str STRING            
DEFINE lc_chin       base.Channel          
DEFINE l_l ,i,l_set            LIKE type_file.num5     
DEFINE l_crip_temp,l_host        STRING          
DEFINE l_greport                         STRING         
DEFINE l_mid_dir      STRING              #$TOP或$CUST最後的DIR NAME  
DEFINE l_num_arr           DYNAMIC ARRAY OF INTEGER       
DEFINE l_tok_param         base.StringTokenizer  


     LET ls_path_win = cl_gre_get_4rpdir(l_gdw01,l_gdw03,"W") #No.FUN-B80097 
     LET ls_dir  = ls_path_win
     LET ls_path_win = os.Path.join(ls_path_win.trim(),g_lang CLIPPED)
     
     LET ls_path_win = os.Path.join(ls_path_win,l_gdw09||".4rp") #No.FUN-B80041
     
        IF l_gdw03="Y" THEN #客製
           LET l_mid_dir=os.Path.basename( FGL_GETENV("CUST"))
        ELSE 
           LET l_mid_dir="tiptop"   
           
        END IF
         LET l_template_dir = os.Path.join(FGL_GETENV("TEMPLATEDRIVE"),l_mid_dir), ls_path_win
     
     IF ((NOT cl_null(FGL_GETENV("TEMPLATEDRIVE"))) AND (NOT cl_null(FGL_GETENV("WINFGLPROFILE")))
         AND (NOT cl_null(FGL_GETENV("WINFGLDIR"))) AND (NOT cl_null(FGL_GETENV("WINGREDIR")))) THEN
     
         
      CALL fgl_report_configureRemoteLocations(l_template_dir,FGL_GETENV("WINFGLPROFILE"),    
                                                FGL_GETENV("WINFGLDIR"),FGL_GETENV("WINGREDIR"))
                                                  
     ELSE
        CALL cl_err('','azz1201',1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM -1
     END IF

       #讀檔
       LET l_crip_temp=""
       LET l_crip_temp=fgl_getenv('CRIP')
       LET l_crip_temp=cl_replace_str(l_crip_temp,"http://","")
       LET l_set=l_crip_temp.getIndexOf("/",1) #抓出/位置                              
       LET l_crip_temp=l_crip_temp.subString(1,l_set-1) #抓出ip

       IF g_user="tiptop" THEN 
            LET l_tok_param = base.StringTokenizer.createExt(l_crip_temp,".","",TRUE)
            LET i=0
            CALL l_num_arr.clear()
            WHILE l_tok_param.hasMoreTokens()
               #DISPLAY l_tok_table.nextToken()
               LET i=i+1
               LET l_num_arr[i] =l_tok_param.nextToken()  
              # DISPLAY i,"l_num_arr:",l_num_arr[i] 
            END WHILE
            #DISPLAY "EXIT WHILE I=",i
            IF i=3 AND l_num_arr[1] IS NULL AND l_num_arr[2] IS NULL AND l_num_arr[3] IS NULL   THEN
               LET l_host=l_crip_temp  
              # DISPLAY "DNS:l_crip_temp:",l_crip_temp
            ELSE   
              # DISPLAY "IP:l_crip_temp:",l_crip_temp
               LET l_cmd = "/etc/hosts"      
               #DISPLAY l_cmd
               LET lc_chin = base.Channel.create() #create new 物件
               CALL lc_chin.openFile(l_cmd,"r") #開啟檔案
               LET l_l=1

               WHILE TRUE   
                      LET l_read_str =lc_chin.readLine() #整行讀入
                      LET l_read_str = l_read_str.trim()       
                      IF l_read_str.getCharAt(1) <> '#' THEN   
                          IF l_read_str.getIndexOf(l_crip_temp,1)>0 THEN #找到此ip 
                             LET l_host=l_read_str.substring(l_crip_temp.getLength()+1,l_read_str.getLength() )
                             LET l_host=cl_replace_str(l_host," ","") 
                             LET l_host=cl_replace_str(l_host,"\t","")
                             LET l_host=l_host.trim()
                             EXIT WHILE 
                          END IF 
                      END IF 
                      IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
               END WHILE                              
               CALL lc_chin.close()

            END IF  
       ELSE 


               LET l_cmd = "/etc/hosts"      
               LET lc_chin = base.Channel.create() #create new 物件
               CALL lc_chin.openFile(l_cmd,"r") #開啟檔案
               LET l_l=1

               WHILE TRUE   
                      LET l_read_str =lc_chin.readLine() #整行讀入
                      LET l_read_str=l_read_str.trim()       
                      IF l_read_str.getCharAt(1)<> "#" THEN  
                          IF l_read_str.getIndexOf(l_crip_temp,1)>0 THEN #找到此ip 
                             LET l_host=l_read_str.substring(l_crip_temp.getLength()+1,l_read_str.getLength() )
                             
                             #DISPLAY "AA_l_host:",l_host
                             LET l_host=cl_replace_str(l_host," ","") 
                             LET l_host=cl_replace_str(l_host,"\t","")
                             LET l_host=l_host.trim()
                             EXIT WHILE 
                          END IF                              
                      END IF          
                      IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
               END WHILE                              
               CALL lc_chin.close()                              
       END IF  
        
       #DISPLAY "l_host:",l_host 
       LET l_greport=fgl_GETENV("WINGREPORT")  
       CALL fgl_report_configureDistributedProcessing(l_host,l_greport)  
       #CALL fgl_report_configureDistributedProcessing(l_host,"6405")

     
END FUNCTION 
#FUN-D10044 -(e)



##################################################
# Private Func..: TRUE
# Library name...: cl_gre_getServerUID
# Descriptions...:
# Input parameter: void
# Return code....: STRING
# Usage..........: CALL cl_gre_getServerUID()
##################################################
FUNCTION cl_gre_getServerUID()   #B2B
   DEFINE
     pid STRING,
     rootNode om.DomNode,
     pidBuf base.StringBuffer

     # Build ID SERVER-PID-MM-DD-HH-MM-SS.F
     # from Server name, Server PID of gviewdoc, current date & time
     #No.FUN-B80097 --start--
     IF NOT (g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]") THEN
     LET rootNode = ui.Interface.getRootNode()   # The root node is UserInterface
     LET pid = rootNode.getAttribute("procId")
     ELSE
        LET pid = FGL_GETPID()
     END IF
     #No.FUN-B80097 --end--
     LET pidBuf = base.StringBuffer.create()
     CALL pidBuf.append(pid)
     CALL pidBuf.append("-"||CURRENT MONTH TO DAY||"-"||CURRENT HOUR TO FRACTION(1))
     CALL pidBuf.replace(":", "-", 0)

     RETURN pidBuf.toString()
END FUNCTION

##################################################
# Library name...: cl_gre_rowcnt
# Descriptions...: 取得資料表資料列數
# Input parameter: p_table          資料表名稱
# Return code....: type_file.num10  資料列數
# Usage..........: LET l_cnt = cl_gre_rowcnt(l_table)
##################################################
FUNCTION cl_gre_rowcnt(p_table)
    DEFINE p_table  STRING
    DEFINE l_sql    STRING
    DEFINE l_cnt    LIKE type_file.num10

    LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,p_table CLIPPED
    PREPARE cl_gre_rowcnt_pre FROM l_sql
    EXECUTE cl_gre_rowcnt_pre INTO l_cnt
    IF SQLCA.SQLCODE THEN
        CALL cl_err('cl_gre_rowcnt_pre:', SQLCA.SQLCODE, 1)
    ELSE
        IF l_cnt <= 0 THEN
            CALL cl_err('!','lib-216',1)
        END IF
    END IF
    RETURN l_cnt
END FUNCTION

##################################################
# Library name...: cl_gre_drop_temptable
# Descriptions...: 刪除GR temp table
# Input parameter: p_table          資料表名稱
# Return code....: none
# Usage..........: CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
##################################################
FUNCTION cl_gre_drop_temptable(p_table)
    DEFINE p_table  STRING
    DEFINE l_sql    STRING
    DEFINE l_table  STRING
    DEFINE l_strtok base.StringTokenizer
    DEFINE l_msg    STRING

    WHENEVER ERROR CONTINUE

    IF cl_null(g_db_type) THEN
        LET g_db_type = cl_db_get_database_type()
    END IF

    DATABASE ds_report

    #ORA必須10g以上,設定為直接刪除table
    IF g_db_type = "ORA" THEN
        EXECUTE IMMEDIATE "PURGE USER_RECYCLEBIN"
        EXECUTE IMMEDIATE "ALTER SESSION SET RECYCLEBIN=OFF"
    END IF

    LET l_strtok = base.StringTokenizer.create(p_table,"|")
    WHILE l_strtok.hasMoreTokens()
        LET l_table = l_strtok.nextToken()
        LET l_table = l_table.trim()

        LET l_sql = "DROP TABLE ",g_cr_db_str CLIPPED,l_table
        LET l_msg = l_sql
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
            LET l_msg = l_msg,"\tERROR: ",SQLCA.SQLCODE
        ELSE
            LET l_msg = l_msg,"\tOK."
        END IF
        DISPLAY l_msg
    END WHILE
END FUNCTION

#No.FUN-B80092 --start--
##################################################
# Private Func..: TRUE
# Library name...: cl_gr_make_apr
# Descriptions...: 呼叫產生簽核圖檔
# Date & Author..: 2011/08/10 By jacklai
# Input parameter: p_template 
# Return code....: none
# Usage..........: CALL cl_gr_make_apr()
##################################################
PRIVATE FUNCTION cl_gr_make_apr(p_template)
    DEFINE l_cnt        LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_tok        base.StringTokenizer
    DEFINE l_key_num    LIKE type_file.num10
    #FUN-BC0063 --start--
    #DEFINE l_key_v      STRING
    DEFINE l_sql        STRING
    DEFINE la_apr_key   ARRAY[5] OF STRING                  #暫存表主鍵欄位名稱
    DEFINE la_apr_tval  ARRAY[5] OF LIKE type_file.chr100   #暫存表主鍵欄位值暫存值
    DEFINE la_apr_val   ARRAY[5] OF STRING                  #暫存表主鍵欄位值
    DEFINE l_str        STRING
    DEFINE l_row_cnt   LIKE type_file.num10                 #已執行的筆數
    #FUN-BC0063 --end--
    DEFINE p_template   STRING                              #FUN-C50037 樣板代號
    
    #更新temp table的簽核圖檔
    IF g_grPageHeader.g_apr_loc != "0" THEN
        #單據數量，用於顯示作業處理進度
        LET l_cnt = 0
        LET l_sql = "SELECT count(*) FROM ",g_cr_db_str CLIPPED,g_cr_table CLIPPED
        PREPARE cl_gr_make_apr_pre FROM l_sql
        EXECUTE cl_gr_make_apr_pre INTO l_cnt

        IF l_cnt > 0 THEN

            #背景作業關掉預設的screen視窗
            IF (g_bgjob = "Y") THEN
                CLOSE WINDOW SCREEN
            ELSE
                CALL cl_progress_bar(l_cnt)   #顯示作業處理進度
            END IF

            #FUN-BC0063 --start--
            #主鍵欄位數量
            CALL la_apr_key.clear()#清空陣列 FUN-BB0157增加
            LET l_key_num = 1
            LET l_str = NULL
            LET l_tok = base.StringTokenizer.createExt(g_cr_apr_key_f CLIPPED,"|","",TRUE)	#指定分隔符號
            WHILE l_tok.hasMoreTokens()	#依序取得子字串
                LET la_apr_key[l_key_num] = l_tok.nextToken() #FUN-BB0157存入陣列
                LET l_key_num = l_key_num + 1
            END WHILE

            #組成select Key值欄位的SQL
            FOR l_i=1 TO 5  #陣列固定5個
                IF cl_null(la_apr_key[l_i]) THEN #若陣列內容是NULL，則補上NULL
                    LET l_str=l_str,"NULL,"
                ELSE
                    LET l_str=l_str,la_apr_key[l_i],"," #若陣列內容不是NULL，則補上陣列值
                END IF   
            END FOR
            #subString去除最後一個,
            LET l_str = l_str.subString(1,l_str.getLength()-1)
            LET l_sql = "SELECT ",l_str ," FROM ",g_cr_db_str CLIPPED,g_cr_table CLIPPED
            DECLARE cl_gr_make_apr_curs CURSOR FROM l_sql
            LET l_row_cnt = 0
            FOREACH cl_gr_make_apr_curs INTO la_apr_tval[1],la_apr_tval[2],la_apr_tval[3],la_apr_tval[4],la_apr_tval[5]
                IF SQLCA.SQLCODE THEN
                    EXIT FOREACH
                END IF
                LET l_row_cnt = l_row_cnt + 1
                FOR l_i = 1 TO 5
                    LET la_apr_val[l_i] = la_apr_tval[l_i]
                END FOR

                #IF NOT (g_bgjob = "Y") THEN                     #FUN-CB0144 mark
                IF NOT (g_bgjob = "Y") OR cl_null(g_bgjob) THEN  #FUN-CB0144 add  多判斷null的情形                IF NOT (g_bgjob = "Y") THEN
                    CALL cl_progressing(l_row_cnt)   #顯示作業處理進度
                END IF

                #報表簽核, FUN-C50037 新增傳入p_template
                CALL cl_prt_apr_img(l_i, g_prog, la_apr_val[1], g_cr_table, la_apr_key, la_apr_val, 0, 0, p_template)
            END FOREACH
            #FUN-BC0063 --end--
        END IF 
    END IF
END FUNCTION

##################################################
# Private Func..: TRUE
# Library name...: cl_gre_get_apr_loc
# Descriptions...: 取得簽核圖檔位置
# Date & Author..: 2011/08/10 By jacklai
# Input parameter: p_gdw14  是否列印簽核
#                  p_gdw15  列印簽核位置
# Return code....: STRING   列印簽核位置(0:不列印簽核/ 1:頁尾/ 2:表尾)
# Usage..........: LET l_loc = cl_gre_get_apr_loc(l_gdw14,l_gdw15)
##################################################
PRIVATE FUNCTION cl_gre_get_apr_loc(p_gdw14,p_gdw15)
    DEFINE p_gdw14  LIKE gdw_file.gdw14
    DEFINE p_gdw15  LIKE gdw_file.gdw15
    DEFINE l_loc    STRING

    #列印簽核位置(0:不列印簽核/ 1:頁尾/ 2:表尾)
    IF cl_null(p_gdw14) THEN
        LET p_gdw14 ="N"   #預設不列印簽核
    END IF
    IF cl_null(p_gdw15) THEN
        LET p_gdw15 ="1"   #預設列印簽核未置於頁尾
    END IF
    IF p_gdw14 = "Y" THEN
        LET l_loc = p_gdw15 CLIPPED
    ELSE
        LET l_loc = "0"
    END IF

    RETURN l_loc
END FUNCTION

##################################################
# Library name...: cl_gre_apr_loc
# Descriptions...: 傳回簽核圖檔位置
# Date & Author..: 2011/08/10 By jacklai
# Input parameter: none
# Return code....: STRING   列印簽核位置(0:不列印簽核/ 1:頁尾/ 2:表尾)
# Usage..........: LET l_loc = cl_gre_apr_loc()
##################################################
FUNCTION cl_gre_apr_loc()
    RETURN g_grPageHeader.g_apr_loc #FUN-C30012 改為系統共用變數
END FUNCTION

##################################################
# Library name...: cl_gre_init_apr
# Descriptions...: 初始化列印簽核相關變數
# Date & Author..: 2011/08/10 By jacklai
# Input parameter: none
# Return code....: none
# Usage..........: CALL cl_gre_init_apr()
##################################################
FUNCTION cl_gre_init_apr()
    LET g_apr_cnt = 0
END FUNCTION
#No.FUN-B80092 --end--

#No.FUN-B80097 --start--
##################################################
# Library name...: cl_gre_get_4rpdir
# Descriptions...: 根據程式代號取得4RP目錄路徑
# Date & Author..: 2011/09/16 By jacklai
# Input parameter: p_gdw01 程式代號
#                  p_gdw03 客製否(Y/N)
# Return code....: STRING  4RP目錄路徑
# Usage..........: LET l_4rpdir = cl_gre_get_4rpdir(l_gdw01,l_gdw03)
##################################################
#FUNCTION cl_gre_get_4rpdir(p_gdw01,p_gdw03) #TQC-C40053 mark
FUNCTION cl_gre_get_4rpdir(p_gdw01,p_gdw03,p_os) #TQC-C40053 add
   DEFINE p_gdw01    LIKE gdw_file.gdw01  #程式代號
   DEFINE p_gdw03    LIKE gdw_file.gdw03  #客製否
   DEFINE p_os       LIKE type_file.chr1  #系統環境 L/W #TQC-C40053 add
   DEFINE ls_mdir    STRING
   DEFINE ls_4rpdir  STRING
   DEFINE l_gao01    LIKE gao_file.gao01  #模組代號
   DEFINE li_cnt     LIKE type_file.num10
   DEFINE l_zz01   LIKE zz_file.zz01     #TQC-C40053
   DEFINE l_zz011  LIKE zz_file.zz011    #TQC-C40053
   DEFINE l_sys    STRING                #TQC-C40053
   DEFINE l_sql    STRING                #TQC-C40053    
   DEFINE l_cnt    LIKE type_file.num5   #TQC-C40053  

 
   LET ls_4rpdir = NULL
   IF NOT cl_null(p_gdw01) THEN
     #TQC-C40053 ADD-START------------
#
        #LET l_zz01 = p_gdw01
        #LET l_sql = "SELECT zz011 FROM ",s_dbstring("ds") CLIPPED,"zz_file WHERE zz01=?"
        #PREPARE p_replang_pre FROM l_sql
        #EXECUTE p_replang_pre USING l_zz01 INTO l_zz011
        #FREE p_replang_pre
        #LET l_sys = l_zz011
        #LET l_sys = l_sys.toLowerCase()
        #IF p_gdw03 = "Y" THEN
            #IF l_sys.getCharAt(1) <> "c" THEN
                #CALL cl_err_msg("",'azz1206',p_gdw01,1)
                #CALL cl_used(g_prog,g_time,2) RETURNING g_time
                #EXIT PROGRAM 
            #ELSE
                #LET ls_mdir = l_sys
            #END IF
        #ELSE
            #LET ls_mdir = l_sys
        #END IF


       LET l_zz01 = p_gdw01
        LET l_sql = "SELECT zz011 FROM ",s_dbstring("ds") CLIPPED,"zz_file WHERE zz01=?"
        PREPARE p_replang_pre FROM l_sql
        EXECUTE p_replang_pre USING l_zz01 INTO l_zz011
        FREE p_replang_pre
        LET l_sys = l_zz011
        LET l_sys = l_sys.toLowerCase()
        IF p_gdw03 = "Y" THEN
            IF l_sys.getCharAt(1) = "a" THEN
               # CALL cl_err_msg("",'azz1206',p_gdw01,1) #FUN-C60012
                LET l_sys = 'c',l_sys.subString(2,l_sys.getLength()) CLIPPED
                LET ls_mdir = l_sys
            ELSE
                LET ls_mdir = l_sys
            END IF
        ELSE
            IF l_sys.getCharAt(1) = "c" THEN
                LET l_sys = l_sys.subString(2,l_sys.getLength())
                LET l_sql = "SELECT count(gao01) FROM ",s_dbstring("ds") CLIPPED,"gao_file WHERE gao01=?"
                PREPARE p_replang_pre1 FROM l_sql
                EXECUTE p_replang_pre1 USING l_zz011 INTO l_cnt
                FREE p_replang_pre1
                IF l_cnt=0 THEN 
                    LET l_sys='a',l_sys
                ELSE 
                    LET ls_mdir = l_sys
                END IF 
            ELSE 
                LET ls_mdir = l_sys                
            END IF 
        END IF

        
        
     #TQC-C40053  ADD-END ---------------







   
      #TQC-C40053 MARK-END---------------
      #IF p_gdw03 = "Y" THEN
         #IF p_gdw01[1,2] = "p_" THEN
            #LET ls_mdir = "czz"
         #ELSE
            #IF p_gdw01[1] = "g" THEN
               #LET ls_mdir = "c",p_gdw01[1,3]
            #ELSE
               #LET ls_mdir = "c",p_gdw01[2,3]
            #END IF
         #END IF
      #ELSE
         #IF p_gdw01[1,2] = "p_" THEN
            #LET ls_mdir = "azz"
         #ELSE
            #LET ls_mdir = p_gdw01[1,3]
         #END IF
      #END IF
      #TQC-C40053 MARK-END---------------
      
      #TQC-C40053 mark-start--------------
      #IF (g_user!='downheal') THEN   #FUN-C40010 add  
      	 #LET li_cnt = 0
         #LET l_gao01 = UPSHIFT(ls_mdir)
         #SELECT COUNT(*) INTO li_cnt FROM gao_file WHERE gao01=l_gao01
         #IF li_cnt > 0 THEN
            #LET ls_4rpdir = os.Path.join(FGL_GETENV(l_gao01),"4rp")
         #DISPLAY 'ls_4rpdir:', ls_4rpdir
         #END IF
      #ELSE   #FUN-C40010 add
         ##DISPLAY 'ls_4rpdir:', ls_4rpdir
#
         #LET ls_4rpdir = "/",ls_mdir,"/4rp"  #FUN-C40010 add
         #DISPLAY 'ls_4rpdir:', ls_4rpdir      #FUN-C40010 add
      #END IF                                         #FUN-C40010 add
      #TQC-C40053 mark-end--------------
      
      #TQC-C40053 add-start---------
          IF p_os="L" THEN   #FUN-C40010 add  
             LET li_cnt = 0
             LET l_gao01 = UPSHIFT(ls_mdir)
             SELECT COUNT(*) INTO li_cnt FROM gao_file WHERE gao01=l_gao01
             IF li_cnt > 0 THEN
                LET ls_4rpdir = os.Path.join(FGL_GETENV(l_gao01),"4rp")
             #DISPLAY 'ls_4rpdir:', ls_4rpdir
             END IF
          END IF 
          IF  p_os="W" THEN
             #DISPLAY 'ls_4rpdir:', ls_4rpdir

             LET ls_4rpdir = "/",ls_mdir,"/4rp"  #FUN-C40010 add
             #DISPLAY 'ls_4rpdir:', ls_4rpdir      #FUN-C40010 add
          END IF                                         #FUN-C40010 add      
      #TQC-C40053 add-end --------
   END IF
   
   RETURN ls_4rpdir
END FUNCTION

##################################################
# Library name...: cl_gre_jmail_filename
# Descriptions...: 取得javamail附件檔名
# Date & Author..: 2011/09/23 By jacklai
# Input parameter: none
# Return code....: STRING 附件檔名
# Usage..........: LET l_file = cl_gre_jmail_filename()
##################################################
FUNCTION cl_gre_jmail_filename()
   DEFINE ls_filename   STRING
   DEFINE ls_date       STRING
   DEFINE ls_time       STRING
   DEFINE l_time        DATETIME YEAR TO FRACTION(5)

   LET l_time = CURRENT YEAR TO FRACTION(5)
   LET ls_date = DATE(l_time) USING "yyyymmdd"
   LET ls_time = cl_replace_str(EXTEND(l_time, HOUR TO FRACTION(5)), ":", "")
   LET ls_time = cl_replace_str(ls_time, ".", "_")
    
   LET ls_filename = g_prog CLIPPED,"_",ls_date.trim(),"_",ls_time.trim()
   RETURN ls_filename
END FUNCTION
#No.FUN-B80097 --end--

##################################################
# Private Func.. : TRUE
# Library name...: cl_gre_history_or_not()
# Descriptions...: 判斷該GR報表是否需要留存歷史報表
# Input parameter:
# Return code....: STRING 該使用者執行該程式時，是否需留存歷史報表(Y/N)
# Usage..........:
##################################################
PRIVATE FUNCTION cl_gre_history_save()   #No.FUN-C10009
DEFINE l_count    INTEGER    #用來儲存資料庫資料筆數
DEFINE l_produce  STRING     #是否留存資料(Y/N)

   LET l_count = 0
   
   SELECT count(*) INTO l_count FROM gdy_file WHERE gdy01 = lc_gdw01
   IF l_count = 0 THEN       #不須留存歷史報表
      LET l_produce = 'N'
      RETURN l_produce
   ELSE
      #該程式代號於gdy_file有維護資料，需依照全部->權限->使用者代號順序確認是否需留存報表
      #抓取全部類別(gdy02='1')
      SELECT count(*) INTO l_count FROM gdy_file  #依gdy04確認是否需留存報表 
      WHERE gdy01 = lc_gdw01 AND gdy02 = '1' AND gdy04 = 'Y'
      IF l_count > 0 THEN    #需要留存  
         LET l_produce = 'Y'
         RETURN l_produce
      END IF         
      
      #依照權限類別抓資料
      SELECT count(*) INTO l_count FROM gdy_file  #依gdy04確認是否需留存報表 
      WHERE gdy01 = lc_gdw01 AND gdy02 = '2' AND gdy03 = g_clas AND gdy04 = 'Y'
      IF l_count > 0 THEN    #需要留存  
         LET l_produce = 'Y'
         RETURN l_produce
      END IF

      #依照使用者代號抓資料
      SELECT count(*) INTO l_count FROM gdy_file  #依gdy04確認是否需留存報表 
      WHERE gdy01 = lc_gdw01 AND gdy02 = '3' AND gdy03 = g_user AND gdy04 = 'Y'
      IF l_count > 0 THEN    #需要留存  
         LET l_produce = 'Y'
         RETURN l_produce
      END IF
      
      #依照'全部->權限->使用者代號'順序確認，資料庫均無資料，代表不須留存
      LET l_produce = 'N'
      RETURN l_produce
   END IF
END FUNCTION


##################################################
# Private Func.. : TRUE
# Library name...: cl_gre_apr_str()
# Descriptions...: GR報表明細類簽核字串列印
# Input parameter: p_template(樣板代號)
# Return code....: 
# Usage..........: 
##################################################
#FUN-C30012 明細類報表組合簽核字串 --START-- 
FUNCTION cl_gre_apr_str(p_template)
DEFINE l_cnt_zz14 LIKE type_file.num10
DEFINE l_str_cnt  LIKE type_file.num10
DEFINE p_template STRING            #FUN-C50037 新增傳入樣板代號
DEFINE l_gdw08    LIKE gdw_file.gdw08

    #若需要列印簽核再執行 FUN-C40085 add
    IF g_grPageHeader.g_apr_loc != "0" THEN
       SELECT count(zz14) INTO l_cnt_zz14 FROM zz_file WHERE zz01=g_prog AND (zz14 IN (2,3,4))
       IF l_cnt_zz14 = 1 THEN       #報表類型是2、3、4,非單據類報表 共用同一種簽核
           #CALL cl_prt_str_cnt(g_prog,"ALL",p_template) #FUN-C50037 傳入樣板代號
           CALL cl_prt_str_cnt(g_prog,"ALL",p_template) #FUN-C50037 傳入樣板代號 #FUN-CB0144 add
           RETURNING l_str_cnt, g_grPageHeader.g_apr_str
       END IF
    END IF

END FUNCTION
#FUN-C30012 明細類報表組合簽核字串 -- END --

FUNCTION cl_gre_zy06() 
DEFINE  p_prog   LIKE zz_file.zz01
DEFINE  l_zx04   LIKE zx_file.zx04
DEFINE  l_zy06   LIKE zy_file.zy06

    #權限類別
     SELECT zx04 INTO l_zx04 FROM zx_file
      WHERE zx01 = g_user

    #取得允許列印方式
     LET l_zy06 = NULL
     SELECT zy06 INTO l_zy06 FROM zy_file
      WHERE zy01 = l_zx04
        AND zy02 = g_gdw01
    
     RETURN l_zy06

END FUNCTION

#FUN-C60029 ----------start---
FUNCTION cl_gre_format_combo(p_zy06,p_field,p_cmd)
DEFINE p_zy06   LIKE zy_file.zy06
DEFINE p_field  STRING
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_combo_value  STRING
DEFINE l_combo_item   STRING
DEFINE l_num,i    LIKE type_file.num5

    LET l_num = 1
    IF p_cmd = 'a' THEN
       LET l_combo_value = "1,"
       LET l_combo_item  = "1:",cl_getmsg('azz1236',g_lang),","
       LET l_num = l_num + 1
    END IF
    IF NOT cl_null(p_zy06) THEN
       FOR i = 1 TO LENGTH(p_zy06)
           CASE p_zy06[i,i]
             WHEN "D" #WORD
               IF p_cmd = 'a' THEN
                  LET l_combo_value = l_combo_value CLIPPED,"7"
               ELSE
                  LET l_combo_value = l_combo_value CLIPPED,"6"
               END IF
               LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1242',g_lang)
               LET l_num = l_num + 1
             WHEN "X" #EXCEL
               IF p_cmd = 'a' THEN
                  #LET l_combo_value = l_combo_value CLIPPED,"3,4,5,6"  #FUN-C70120 mark
                  LET l_combo_value = l_combo_value CLIPPED,"3"         #FUN-C70120 add
               ELSE
                  #LET l_combo_value = l_combo_value CLIPPED,"2,3,4,5"   #FUN-C70120 mark
                  LET l_combo_value = l_combo_value CLIPPED,"2"          #FUN-C70120 add
               END IF
               LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1238',g_lang),","
               LET l_num = l_num + 1
               #FUN-C70120 mark----start-------
               #LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1239',g_lang),","
               #LET l_num = l_num + 1
               #LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1240',g_lang),","
               #LET l_num = l_num + 1
               #LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1241',g_lang)
               #LET l_num = l_num + 1
               #FUN-C70120 mark----end----------
             #FUN-C70120 add-------start---------------
              WHEN "B" #XLS(per page)
               IF p_cmd = 'a' THEN
                  LET l_combo_value = l_combo_value CLIPPED,"4"
               ELSE
                  LET l_combo_value = l_combo_value CLIPPED,"3"
               END IF
               LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1239',g_lang),","
               LET l_num = l_num + 1               
              WHEN "E" #XLSX
               IF p_cmd = 'a' THEN
                  LET l_combo_value = l_combo_value CLIPPED,"5"
               ELSE
                  LET l_combo_value = l_combo_value CLIPPED,"4"
               END IF
               LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1240',g_lang),","
               LET l_num = l_num + 1               
              WHEN "F" #XLSX(per page)
               IF p_cmd = 'a' THEN
                  LET l_combo_value = l_combo_value CLIPPED,"6"
               ELSE
                  LET l_combo_value = l_combo_value CLIPPED,"5"
               END IF               
               LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1241',g_lang)
               LET l_num = l_num + 1            
            #FUN-C70120 add-------end
               
             WHEN "P" #PDF
               IF p_cmd = 'a' THEN
                  LET l_combo_value = l_combo_value CLIPPED,"2"
               ELSE
                  LET l_combo_value = l_combo_value CLIPPED,"1"
               END IF
               LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1237',g_lang)
               LET l_num = l_num + 1
             WHEN "I" #HTML
               IF p_cmd = 'a' THEN
                  LET l_combo_value = l_combo_value CLIPPED,"8"
               ELSE
                  LET l_combo_value = l_combo_value CLIPPED,"7"
               END IF
               LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1243',g_lang)
               LET l_num = l_num + 1
             WHEN "J" #Mail
               IF p_cmd = 'a' THEN
                  LET l_combo_value = l_combo_value CLIPPED,"9"
                  LET l_combo_item  = l_combo_item CLIPPED,l_num USING '&',":",cl_getmsg('azz1244',g_lang)
                  LET l_num = l_num + 1
               ELSE
                  CONTINUE FOR
               END IF
           END CASE
           IF i < LENGTH(p_zy06) THEN 
              LET l_combo_value = l_combo_value , ","
              LET l_combo_item = l_combo_item , ","
           END IF
       END FOR
    ELSE
       IF p_cmd = 'a' THEN
          LET l_combo_value = l_combo_value CLIPPED,"2,3,4,5,6,7,8,9"
          LET l_combo_item  = l_combo_item CLIPPED,"2:",cl_getmsg('azz1237',g_lang)
                                              ,",","3:",cl_getmsg('azz1238',g_lang)
                                              ,",","4:",cl_getmsg('azz1239',g_lang)
                                              ,",","5:",cl_getmsg('azz1240',g_lang)
                                              ,",","6:",cl_getmsg('azz1241',g_lang)
                                              ,",","7:",cl_getmsg('azz1242',g_lang)
                                              ,",","8:",cl_getmsg('azz1243',g_lang)
                                              ,",","9:",cl_getmsg('azz1244',g_lang)
      ELSE
          LET l_combo_value = l_combo_value CLIPPED,"1,2,3,4,5,6,7"
          LET l_combo_item  = l_combo_item CLIPPED,"1:",cl_getmsg('azz1237',g_lang)
                                              ,",","2:",cl_getmsg('azz1238',g_lang)
                                              ,",","3:",cl_getmsg('azz1239',g_lang)
                                              ,",","4:",cl_getmsg('azz1240',g_lang)
                                              ,",","5:",cl_getmsg('azz1241',g_lang)
                                              ,",","6:",cl_getmsg('azz1242',g_lang)
                                              ,",","7:",cl_getmsg('azz1243',g_lang)

      END IF
    END IF
    CALL cl_set_combo_items(p_field,l_combo_value,l_combo_item)

END FUNCTION
#FUN-C60029 ----------end---



#FUN-C60039--add--start
FUNCTION cl_gre_chk_tiptopgroup()
   DEFINE   l_cmd       STRING
   DEFINE   l_channel    base.Channel
   DEFINE   l_cnt        LIKE type_file.num5
   DEFINE   l_result     STRING
   DEFINE   l_chk        LIKE type_file.chr1

   LET l_cmd = "groups"
   LET l_channel = base.Channel.create()
   CALL l_channel.openPipe(l_cmd,"r")
   CALL l_channel.setDelimiter("")
   WHILE l_channel.read(l_result)
      LET l_cnt= l_result.getIndexOf("tiptop",1)
      IF l_cnt > 0 THEN
         LET l_chk = 'Y'
      ELSE
         LET l_chk = 'N'
      END IF
   END WHILE
   CALL l_channel.close()

   RETURN l_chk

END FUNCTION


#FUN-C60039--add--end
#FUN-C80015 --START--
PRIVATE FUNCTION cl_gre_chk_gdy05()
DEFINE l_count    INTEGER    #用來儲存資料庫資料筆數
DEFINE l_gdy05    LIKE gdy_file.gdy05

   LET l_count = 0

   SELECT count(*) INTO l_count FROM gdy_file WHERE gdy01 = lc_gdw01
   IF l_count = 0 THEN       #不須留存歷史報表
      RETURN NULL
   ELSE
      #該程式代號於gdy_file有維護資料，需依照全部->權限->使用者代號順序確認是否需留存報表
      #抓取全部類別(gdy02='1')
      SELECT gdy05 INTO l_gdy05 FROM gdy_file  #依gdy04確認是否需留存報表
      WHERE gdy01 = lc_gdw01 AND gdy02 = '1' AND gdy04 = 'Y'
      IF NOT cl_null(l_gdy05) THEN    #需要留存
         RETURN l_gdy05
      END IF
      
      #依照權限類別抓資料
      SELECT gdy05 INTO l_gdy05 FROM gdy_file  #依gdy04確認是否需留存報表
      WHERE gdy01 = lc_gdw01 AND gdy02 = '2' AND gdy03 = g_clas AND gdy04 = 'Y'
      IF NOT cl_null(l_gdy05) THEN    #需要留存
         RETURN l_gdy05
      END IF

      #依照使用者代號抓資料
      SELECT gdy05 INTO l_gdy05 FROM gdy_file  #依gdy04確認是否需留存報表
      WHERE gdy01 = lc_gdw01 AND gdy02 = '3' AND gdy03 = g_user AND gdy04 = 'Y'
      IF NOT cl_null(l_gdy05) THEN    #需要留存
         RETURN l_gdy05
      END IF

      #依照'全部->權限->使用者代號'順序確認，資料庫均無資料，代表不須留存
      RETURN NULL
   END IF
END FUNCTION
#FUN-C80015 --END--

#FUN-D10077 讀取4rp紙張尺寸，判斷是否為中一刀
FUNCTION cl_gre_chk_halfletter(p_path)
DEFINE p_path       STRING
DEFINE l_rootnode   om.DomNode
DEFINE l_curnode    om.DomNode
DEFINE l_parnode    om.DomNode
DEFINE l_nodes      om.NodeList 
DEFINE l_doc        om.DomDocument
DEFINE l_paperwidth,l_paperlength        STRING
DEFINE l_tagname    STRING
DEFINE l_i          LIKE type_file.num5

    LET l_doc = om.DomDocument.createFromXmlFile(p_path)
    IF l_doc IS NOT NULL THEN
        LET l_rootnode = l_doc.getDocumentElement()
        IF l_rootnode IS NOT NULL THEN     
           #抓取紙張大小   
           LET l_tagname = "report:Settings"
           LET l_nodes = l_rootnode.selectByTagName(l_tagname)
           FOR l_i = 1 TO l_nodes.getLength()
               LET l_curnode=l_nodes.item(l_i)
               EXIT FOR
           END FOR
           LET l_paperwidth =l_curnode.getAttribute("RWPageWidth")
           LET l_paperlength=l_curnode.getAttribute("RWPageLength")

           IF (l_paperwidth='21.59cm' OR l_paperwidth='8.5inch') AND
              (l_paperlength='13.97cm' OR l_paperlength='5.5inch') THEN
              RETURN TRUE
           ELSE
              RETURN FALSE
           END IF
        END IF 
    END IF
    RETURN FALSE

END FUNCTION


#FUN-D10108 ---- (S)
#依預設值進行排序
#優先序為1.客製否(gdw03) 2.使用者(gdw05) 3.預設樣板(gdw17)
FUNCTION cl_gre_b_fill_sort()
DEFINE l_i,l_j,l_max  LIKE type_file.num10
DEFINE l_gdw_tmp   DYNAMIC ARRAY OF RECORD
                      pick    VARCHAR,             #顯示勾選
                      gfs03      LIKE gfs_file.gfs03, #樣板說明
                      gdw03      LIKE gdw_file.gdw03, #客製否
                      gdw09      LIKE gdw_file.gdw09, #樣板代號
                      gdw11      LIKE gdw_file.gdw11,
                      gdw12      LIKE gdw_file.gdw12,
                      gdw13      LIKE gdw_file.gdw13,
                      gdw14      LIKE gdw_file.gdw14, 
                      gdw15      LIKE gdw_file.gdw15, 
                      gdw02      LIKE gdw_file.gdw02, 
                      gdw08      LIKE gdw_file.gdw08,  
                      gdw05      LIKE gdw_file.gdw05, #使用者
                      gdw17      LIKE gdw_file.gdw17, #預設樣板
                      gdw06      LIKE gdw_file.gdw06, #行業別 #FUN-D40043
                      sort_num   LIKE type_file.num5  #排序碼(越大越優先)
                  END RECORD
DEFINE l_gdw_t    RECORD
                      pick    VARCHAR,             #顯示勾選
                      gfs03      LIKE gfs_file.gfs03, #樣板說明
                      gdw03      LIKE gdw_file.gdw03, #客製否
                      gdw09      LIKE gdw_file.gdw09, #樣板代號
                      gdw11      LIKE gdw_file.gdw11,
                      gdw12      LIKE gdw_file.gdw12,
                      gdw13      LIKE gdw_file.gdw13,
                      gdw14      LIKE gdw_file.gdw14, 
                      gdw15      LIKE gdw_file.gdw15, 
                      gdw02      LIKE gdw_file.gdw02, 
                      gdw08      LIKE gdw_file.gdw08,  
                      gdw05      LIKE gdw_file.gdw05, #使用者
                      gdw04      LIKE gdw_file.gdw04, #權限類別
                      gdw17      LIKE gdw_file.gdw17, #預設樣板
                      gdw06      LIKE gdw_file.gdw06, #行業別 #FUN-D40043
                      sort_num   LIKE type_file.num5  #排序碼(越大越優先)
                  END RECORD

    IF g_gdw.getlength() = 0 THEN RETURN END IF

   #先跑一圈，賦予每一行的樣板排序碼
    LET l_max = 0 
    FOR l_i = 1 TO g_gdw.getlength()
        IF cl_null(g_gdw[l_i].gdw02) THEN CONTINUE FOR END IF
        LET l_gdw_tmp[l_i].sort_num = 0
        IF g_gdw[l_i].gdw17='Y' THEN
           LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_i].sort_num + 1 
        END IF
        IF g_gdw[l_i].gdw04=g_clas THEN
           #LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_i].sort_num + 1 
           LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_i].sort_num + 2 #FUN-D40043
        END IF
        IF g_gdw[l_i].gdw05=g_user THEN
           #LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_i].sort_num + 1 
           LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_i].sort_num + 4 #FUN-D40043
        END IF
       #FUN-D40043---(S)
        IF g_gdw[l_i].gdw06=g_sma.sma124 THEN
           LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_i].sort_num + 8 
        END IF
       #FUN-D40043---(E)
        IF g_gdw[l_i].gdw03='Y' THEN
           #LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_i].sort_num + 1 
           LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_i].sort_num + 16  #FUN-D40043
        END IF
        IF l_gdw_tmp[l_i].sort_num > l_max THEN
           LET l_max = l_gdw_tmp[l_i].sort_num 
        END IF
    END FOR
   
   #用選擇排序法
    FOR l_i = 1 TO l_gdw_tmp.getlength()
        FOR l_j = l_i+1 TO l_gdw_tmp.getlength()
            IF l_gdw_tmp[l_j].sort_num > l_gdw_tmp[l_i].sort_num THEN
              #資料互換
               INITIALIZE l_gdw_t.* TO NULL
               LET l_gdw_t.gfs03 = g_gdw[l_i].gfs03
               LET l_gdw_t.gdw03 = g_gdw[l_i].gdw03
               LET l_gdw_t.gdw09 = g_gdw[l_i].gdw09
               LET l_gdw_t.gdw11 = g_gdw[l_i].gdw11
               LET l_gdw_t.gdw12 = g_gdw[l_i].gdw12
               LET l_gdw_t.gdw13 = g_gdw[l_i].gdw13
               LET l_gdw_t.gdw14 = g_gdw[l_i].gdw14
               LET l_gdw_t.gdw15 = g_gdw[l_i].gdw15
               LET l_gdw_t.gdw02 = g_gdw[l_i].gdw02
               LET l_gdw_t.gdw08 = g_gdw[l_i].gdw08
               LET l_gdw_t.gdw05 = g_gdw[l_i].gdw05
               LET l_gdw_t.gdw04 = g_gdw[l_i].gdw04
               LET l_gdw_t.gdw17 = g_gdw[l_i].gdw17
               LET l_gdw_t.gdw06 = g_gdw[l_i].gdw06 #FUN-D40043
               LET l_gdw_t.sort_num = l_gdw_tmp[l_i].sort_num
                
               LET g_gdw[l_i].gfs03 = g_gdw[l_j].gfs03
               LET g_gdw[l_i].gdw03 = g_gdw[l_j].gdw03
               LET g_gdw[l_i].gdw09 = g_gdw[l_j].gdw09
               LET g_gdw[l_i].gdw11 = g_gdw[l_j].gdw11
               LET g_gdw[l_i].gdw12 = g_gdw[l_j].gdw12
               LET g_gdw[l_i].gdw13 = g_gdw[l_j].gdw13
               LET g_gdw[l_i].gdw14 = g_gdw[l_j].gdw14
               LET g_gdw[l_i].gdw15 = g_gdw[l_i].gdw15
               LET g_gdw[l_i].gdw02 = g_gdw[l_j].gdw02
               LET g_gdw[l_i].gdw08 = g_gdw[l_j].gdw08
               LET g_gdw[l_i].gdw05 = g_gdw[l_j].gdw05
               LET g_gdw[l_i].gdw04 = g_gdw[l_j].gdw04
               LET g_gdw[l_i].gdw17 = g_gdw[l_j].gdw17
               LET g_gdw[l_i].gdw06 = g_gdw[l_j].gdw06 #FUN-D40043
               LET l_gdw_tmp[l_i].sort_num = l_gdw_tmp[l_j].sort_num
               
               LET g_gdw[l_j].gfs03 = l_gdw_t.gfs03
               LET g_gdw[l_j].gdw03 = l_gdw_t.gdw03
               LET g_gdw[l_j].gdw09 = l_gdw_t.gdw09
               LET g_gdw[l_j].gdw11 = l_gdw_t.gdw11
               LET g_gdw[l_j].gdw12 = l_gdw_t.gdw12
               LET g_gdw[l_i].gdw13 = l_gdw_t.gdw13
               LET g_gdw[l_j].gdw14 = l_gdw_t.gdw14
               LET g_gdw[l_j].gdw15 = l_gdw_t.gdw15
               LET g_gdw[l_j].gdw02 = l_gdw_t.gdw02
               LET g_gdw[l_j].gdw08 = l_gdw_t.gdw08
               LET g_gdw[l_j].gdw05 = l_gdw_t.gdw05
               LET g_gdw[l_j].gdw04 = l_gdw_t.gdw04
               LET g_gdw[l_j].gdw17 = l_gdw_t.gdw17
               LET g_gdw[l_j].gdw06 = l_gdw_t.gdw06 #FUN-D40043
               LET l_gdw_tmp[l_j].sort_num = l_gdw_t.sort_num
            END IF
        END FOR
    END FOR
    
    FOR l_i = 1 TO l_gdw_tmp.getlength()
        IF l_i=1 THEN
           LET g_gdw[l_i].pick = 'Y'
        ELSE
           LET g_gdw[l_i].pick = 'N'
        END IF
    END FOR
 

END FUNCTION

FUNCTION cl_gre_set_default(p_ac)
DEFINE l_gdw  RECORD LIKE gdw_file.*
DEFINE p_ac   LIKE type_file.num5

    IF p_ac <=0 THEN RETURN FALSE END IF #FUN-D10135 add FALSE

    IF g_gdw[p_ac].gdw17 = 'N' THEN
       IF cl_confirm('azz1305') THEN 
          IF g_gdw[p_ac].gdw17='N' THEN #不是預設，則UPDATE為Y，並把其它UPDATE為N
             INITIALIZE l_gdw.* TO NULL
             SELECT * INTO l_gdw.* FROM gdw_file
              WHERE gdw08 = g_gdw[p_ac].gdw08
             UPDATE gdw_file SET gdw17='Y'
              WHERE gdw08 = g_gdw[p_ac].gdw08
             UPDATE gdw_file SET gdw17='N'
              WHERE gdw01 = l_gdw.gdw01
               #AND gdw02 = l_gdw.gdw02
                AND gdw04 = l_gdw.gdw04
                AND gdw05 = l_gdw.gdw05
                AND gdw06 = l_gdw.gdw06
                AND gdw08 <>l_gdw.gdw08
             CALL cl_gre_b_fill()
             RETURN TRUE
          END IF
       ELSE
          RETURN FALSE
       END IF
    ELSE
       CALL cl_err('','azz1307',1)
       RETURN FALSE
    END IF

END FUNCTION

#FUN-D10108 ---- (E)
