# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi080.4gl
# Descriptions...: 銀行名稱
# Date & Author..: 91/06/21 By Lee
# Modify.........: 99/07/31 By Carol:nmt03 type 改為smallint 
# Modify.........: MOD-470578 04/07/29 By Kitty 預設nmtacti             
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/11 By pengu 報表轉XML
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制  
# Modify.........: No.MOD-590109 05/09/08 By kim 按"匯出Excel"無任何作用
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730032 07/03/32 By chenl 網絡銀行功能，此程序新增nmt04-nmt12共9個欄位。
# Modify.........: No.TQC-740058 07/04/13 By Judy 單身入賬日數無控管
# Modify.........: No.FUN-7B0095 07/11/19 By Smapmin 報表格式修改為crystal reports
# Modify.........: No.FUN-870067 08/07/15 By douzh 新增匯豐銀行接口
# Modify.........: NO.FUN-870037 08/09/10 BY Yiting 增加地區別判斷，不需要的欄位予以隱藏
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.MOD-990061 09/09/07 BY sabrina nmt04為網銀欄位，只有地區別為大陸版且有使用網銀功能時才可顯示
# Modify.........: No.FUN-A20010 10/03/01 By chenmoyan anmt04不限制只有大陸版才可顯示
# Modify.........: No.MOD-B20075 11/02/18 By Dido nmt04 預設值僅大陸版使用
# Modify.........: No.TQC-B80113 11/08/12 By guoch nmt13国家/区域编号未做检查
# Modify.........: No.TQC-B80114 11/08/15 By guoch nmt06开户行省份未做检查
# Modify.........: No.TQC-B80137 11/08/17 By lixia 開戶行城市增加管控
# Modify.........: No.TQC-B80147 11/08/18 By lixia 開戶行區縣增加管控
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_nmt           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables) No:8251
        nmt01       LIKE nmt_file.nmt01,       #銀行編號
        nmt02       LIKE nmt_file.nmt02,       #簡稱
        nmt03       LIKE nmt_file.nmt03,       #Days
        nmt14       LIKE nmt_file.nmt14,       #NO.FUN-870037
        nmt12       LIKE nmt_file.nmt12,       #接口來源銀行代碼 #No.FUN-870067 
        nmt11       LIKE nmt_file.nmt11,       #網絡銀行接口版本 #No.FUN-870067 
        nmt04       LIKE nmt_file.nmt04,       #所屬銀行代碼     #No.FUN-730032  
        nmt05       LIKE nmt_file.nmt05,       #所屬銀行名稱     #No.FUN-730032  
        nmt13       LIKE nmt_file.nmt13,       #國家/地區代碼    #No.FUN-870067 
        nmt06       LIKE nmt_file.nmt06,       #開戶行省份       #No.FUN-730032 
        nmt07       LIKE nmt_file.nmt07,       #開戶行城市       #No.FUN-730032 
        nmt08       LIKE nmt_file.nmt08,       #開戶行區縣       #No.FUN-730032
        nmt09       LIKE nmt_file.nmt09,       #系統內分行編碼   #No.FUN-730032   
        nmt10       LIKE nmt_file.nmt10,       #接口系統代碼     #No.FUN-730032 
#       nmt11       LIKE nmt_file.nmt11,       #網絡銀行接口版本 #No.FUN-730032   #No.FUN-870067 
#       nmt12       LIKE nmt_file.nmt12,       #接口來源銀行代碼 #No.FUN-730032   #No.FUN-870067
        nmtacti     LIKE nmt_file.nmtacti      #No.FUN-680107 VARCHAR(1)
                    END RECORD,
    g_nmt_t         RECORD                 #程式變數 (舊值)
        nmt01       LIKE nmt_file.nmt01,   #銀行編號
        nmt02       LIKE nmt_file.nmt02,   #簡稱
        nmt03       LIKE nmt_file.nmt03,   #Days
        nmt14       LIKE nmt_file.nmt14,       #NO.FUN-870037
        nmt12       LIKE nmt_file.nmt12,   #接口來源銀行代碼 #No.FUN-870067 
        nmt11       LIKE nmt_file.nmt11,   #網絡銀行接口版本 #No.FUN-870067 
        nmt04       LIKE nmt_file.nmt04,   #所屬銀行代碼     #No.FUN-730032
        nmt05       LIKE nmt_file.nmt05,   #所屬銀行名稱     #No.FUN-730032
        nmt13       LIKE nmt_file.nmt13,   #國家/地區代碼    #No.FUN-870067 
        nmt06       LIKE nmt_file.nmt06,   #開戶行省份       #No.FUN-730032
        nmt07       LIKE nmt_file.nmt07,   #開戶行城市       #No.FUN-730032
        nmt08       LIKE nmt_file.nmt08,   #開戶行區縣       #No.FUN-730032
        nmt09       LIKE nmt_file.nmt09,   #系統內分行編碼   #No.FUN-730032
        nmt10       LIKE nmt_file.nmt10,   #接口系統代碼     #No.FUN-730032
#       nmt11       LIKE nmt_file.nmt11,   #網絡銀行接口版本 #No.FUN-730032   #No.FUN-870067 
#       nmt12       LIKE nmt_file.nmt12,       #接口來源銀行代碼 #No.FUN-730032   #No.FUN-870067
        nmtacti     LIKE nmt_file.nmtacti  #No.FUN-680107 VARCHAR(1)
                    END RECORD,
     g_wc2,g_sql    STRING,                #No.FUN-580092 HCN 
    g_wc2_1         STRING,   #FUN-7B0095
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt      LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i        LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5   #FUN-570108 #No.FUN-680107 SMALLINT
DEFINE g_str        STRING                    #FUN-7B0095   
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW i080_w AT p_row,p_col WITH FORM "anm/42f/anmi080"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    #NO.FUN-870037 start--
    IF g_aza.aza26 <>'2' THEN  #非大陸版 
#      CALL cl_set_comp_visible("nmt04,nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmt11,nmt12",FALSE)      #MOD-990061 add nmt04 #FUN-A20010 
       CALL cl_set_comp_visible("nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmt11,nmt12",FALSE)      #MOD-990061 add nmt04 #FUN-A20010 
    ELSE 
       CALL cl_set_comp_visible("nmt04,nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmt11,nmt12",TRUE)       #MOD-990061 add nmt04 
    END IF  
    #NO.FUN-870037 end----
 
   #No.FUN-730032--begin--
    #IF g_aza.aza73='N' THEN
    IF g_aza.aza26 = '2' THEN   #NO.FUN-870037
       IF g_aza.aza73 = 'N' THEN   #不使用網銀
           CALL cl_set_comp_visible("nmt04,nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmt11,nmt12",FALSE)    #No.FUN-870067 add nmt13
       ELSE
           CALL cl_set_comp_visible("nmt04,nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmt11,nmt12",TRUE)   #No.FUN-870067 add nmt13
       END IF
    END IF  
   #No.FUN-730032--end--
 
 
    LET g_wc2 = '1=1' CALL i080_b_fill(g_wc2)
    CALL i080_menu()
    CLOSE WINDOW i080_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION i080_menu()
 
   WHILE TRUE
      CALL i080_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i080_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i080_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i080_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmt),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i080_q()
   CALL i080_b_askkey()
END FUNCTION
 
FUNCTION i080_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用        #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                 #可新增否          #No.FUN-680107                         
    l_allow_delete  LIKE type_file.num5,                 #可刪除否          #No.FUN-680107
    l_bankname      LIKE nmt_file.nmt05,                 #所屬銀行名稱，網銀功能時抓取固定內容，僅為初始值      #No.FUN-730032          
    l_bankver       LIKE nmt_file.nmt11,                 #網絡銀行接口版本，網銀功能時抓取固定內容，僅為初始值  #No.FUN-730032 
    l_bankcode      LIKE nmt_file.nmt04                  #所屬銀行代碼，網銀功能時抓取固定內容，僅為初始值      #No.FUN-730032 
DEFINE l_cnt        LIKE type_file.num5                  #TQC-B80113 
 
    LET g_action_choice = ""                                                    
 
    IF s_shut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
 
#   LET g_forupd_sql = "SELECT nmt01,nmt02,nmt03,nmt04,nmt05,nmt06,nmt07,nmt08,nmt09,nmt10,nmt11,nmt12,nmtacti ",         #No.FUN-730032 add nmt04-nmt12
#    LET g_forupd_sql = "SELECT nmt01,nmt02,nmt03,nmt12,nmt11,nmt04,nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmtacti ",   #No.FUN-870067
    LET g_forupd_sql = "SELECT nmt01,nmt02,nmt03,nmt14,nmt12,nmt11,nmt04,nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmtacti ",   #No.FUN-870067  #NO.FUN-870037
                       "  FROM nmt_file WHERE nmt01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i080_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_nmt
            WITHOUT DEFAULTS
            FROM s_nmt.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT                                                            
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)                                           
         END IF
            
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_nmt_t.* = g_nmt[l_ac].*  #BACKUP
#No.FUN-570108 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i080_set_entry(p_cmd)                                      
                CALL i080_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end              
                BEGIN WORK
                OPEN i080_bcl USING g_nmt_t.nmt01
                IF STATUS THEN
                   CALL cl_err("OPEN i080_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i080_bcl INTO g_nmt[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_nmt_t.nmt01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD nmt01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i080_set_entry(p_cmd)                                          
            CALL i080_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end         
            INITIALIZE g_nmt[l_ac].* TO NULL      #900423
             LET g_nmt[l_ac].nmtacti='Y'           #MOD-470578
            #No.FUN-730032--begin--
             LET l_bankcode = ''        #MOD-B20075 
             IF g_aza.aza26 = '2' THEN  #MOD-B20075
                CALL cl_getmsg('anm-316',2) RETURNING l_bankcode
             END IF                     #MOD-B20075
             LET g_nmt[l_ac].nmt04 = l_bankcode
             CALL cl_getmsg('anm-315',2) RETURNING l_bankname
             LET g_nmt[l_ac].nmt05 = l_bankname
             CALL cl_getmsg('anm-317',2) RETURNING l_bankver 
             LET g_nmt[l_ac].nmt11 = l_bankver
#No.FUN-870067--begin
             IF cl_null(g_aza.aza74) THEN
                LET g_nmt[l_ac].nmt12 = g_aza.aza78
             ELSE
                LET g_nmt[l_ac].nmt12 = g_aza.aza74
             END IF
#No.FUN-870067--end
            #No.FUN-730032--end--
            LET g_nmt_t.* = g_nmt[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD nmt01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
              #CLOSE i080_bcl                                                   
              #CALL g_nmt.deleteElement(l_ac)                                   
              #IF g_rec_b != 0 THEN                                             
              #   LET g_action_choice = "detail"                                
              #   LET l_ac = l_ac_t                                             
              #END IF                                                           
              #EXIT INPUT
            END IF                                                           
            INSERT INTO nmt_file(nmt01,nmt02,nmt03,nmt04,nmt05,nmt06,
                                 nmt07,nmt08,nmt09,nmt10,nmt11,nmt12,nmt13,
                                 nmt14,nmtacti)     #No.FUN-870067  add nmt13  #no.FUN-870037
            VALUES(g_nmt[l_ac].nmt01,g_nmt[l_ac].nmt02,
                   g_nmt[l_ac].nmt03,g_nmt[l_ac].nmt04,
                   g_nmt[l_ac].nmt05,g_nmt[l_ac].nmt06,
                   g_nmt[l_ac].nmt07,g_nmt[l_ac].nmt08,
                   g_nmt[l_ac].nmt09,g_nmt[l_ac].nmt10,
                   g_nmt[l_ac].nmt11,g_nmt[l_ac].nmt12,
                   g_nmt[l_ac].nmt13,g_nmt[l_ac].nmt14,  #no.FUN-870037 add nmt14
                   g_nmt[l_ac].nmtacti)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nmt[l_ac].nmt01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("ins","nmt_file",g_nmt[l_ac].nmt01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
              #LET g_nmt[l_ac].* = g_nmt_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
             END IF
 
        AFTER FIELD nmt01                        #check 編號是否重複
            IF g_nmt[l_ac].nmt01 != g_nmt_t.nmt01 OR
               (g_nmt[l_ac].nmt01 IS NOT NULL AND g_nmt_t.nmt01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM nmt_file
                    WHERE nmt01 = g_nmt[l_ac].nmt01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nmt[l_ac].nmt01 = g_nmt_t.nmt01
                    NEXT FIELD nmt01
                END IF
            END IF
#TQC-740058.....begin                                                           
        AFTER FIELD nmt03                                                       
            IF NOT cl_null(g_nmt[l_ac].nmt03) THEN                              
               IF g_nmt[l_ac].nmt03 < 0 THEN                                    
                  CALL cl_err(g_nmt[l_ac].nmt03,'aim1007',0)                    
                  NEXT FIELD nmt03                                              
               END IF                                                           
            END IF                                                              
#TQC-740058.....end
            
#No.FUN-870067--begin                                                           
        AFTER FIELD nmt12   
            IF NOT cl_null(g_nmt[l_ac].nmt12) THEN                              
               IF g_aza.aza78 = g_nmt[l_ac].nmt12 THEN 
                  SELECT nmv17 INTO g_nmt[l_ac].nmt11 FROM nmv_file
                   WHERE nmv01 = g_nmt[l_ac].nmt12
                  DISPLAY g_nmt[l_ac].nmt11
                  DISPLAY g_nmt[l_ac].nmt12
                  CALL cl_set_comp_required("nmt04,nmt05,nmt06,nmt07,nmt09,nmt10",FALSE)
               ELSE
                  CALL cl_set_comp_required("nmt04,nmt05,nmt06,nmt07,nmt09,nmt10",TRUE)
               END IF                                                              
            ELSE
               CALL cl_err(g_nmt[l_ac].nmt12,'mfg0037',0)                    
               NEXT FIELD nmt12                                              
            END IF                                                              
 
        AFTER FIELD nmt04  
            IF cl_null(g_nmt[l_ac].nmt04) THEN                              
               IF g_aza.aza78 != g_nmt[l_ac].nmt12 THEN 
                  CALL cl_err(g_nmt[l_ac].nmt04,'anm-103',0) 
                  NEXT FIELD nmt04               
               END IF  
            END IF    
 
        AFTER FIELD nmt05  
            IF cl_null(g_nmt[l_ac].nmt05) THEN                              
               IF g_aza.aza78 != g_nmt[l_ac].nmt12 THEN 
                  CALL cl_err(g_nmt[l_ac].nmt05,'anm-103',0) 
                  NEXT FIELD nmt05  
               END IF  
            END IF    
 
        AFTER FIELD nmt06  
            IF cl_null(g_nmt[l_ac].nmt06) THEN                              
               IF g_aza.aza78 != g_nmt[l_ac].nmt12 THEN 
                  CALL cl_err(g_nmt[l_ac].nmt06,'anm-103',0) 
                  NEXT FIELD nmt06  
               END IF  
           #TQC-B80114  --begin
            ELSE  
               LET l_cnt = 0
               SELECT COUNT(too02) INTO l_cnt FROM too_file
                WHERE too02 = g_nmt[l_ac].nmt06
                  AND tooacti = 'Y'
               IF l_cnt <= 0 OR cl_null(l_cnt) THEN
                  CALL cl_err(g_nmt[l_ac].nmt06,'anm-356',0)
                  NEXT FIELD nmt06
               END IF
           #TQC-B80114  --end
            END IF    
 
        AFTER FIELD nmt07  
            IF cl_null(g_nmt[l_ac].nmt07) THEN                              
               IF g_aza.aza78 != g_nmt[l_ac].nmt12 THEN 
                  CALL cl_err(g_nmt[l_ac].nmt07,'anm-103',0) 
                  NEXT FIELD nmt07  
               END IF  
            #TQC-B80137--add--str--
            ELSE
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM top_file
                WHERE top02 = g_nmt[l_ac].nmt07
                  AND topacti = 'Y'
               IF l_cnt <= 0 OR cl_null(l_cnt) THEN
                  CALL cl_err(g_nmt[l_ac].nmt07,'anm-357',0)
                  NEXT FIELD nmt07
               END IF
            #TQC-B80137--add--end--
            END IF    

        #TQC-B80147--add--str--
        AFTER FIELD nmt08
           IF NOT cl_null(g_nmt[l_ac].nmt08) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM toq_file
               WHERE toq02 = g_nmt[l_ac].nmt08
                 AND toqacti = 'Y'
              IF l_cnt <= 0 OR cl_null(l_cnt) THEN
                 CALL cl_err(g_nmt[l_ac].nmt08,'anm-358',0)
                 NEXT FIELD nmt08
              END IF
          END IF
        #TQC-B80147--add--end--
 
        AFTER FIELD nmt09  
            IF cl_null(g_nmt[l_ac].nmt09) THEN                              
               IF g_aza.aza78 != g_nmt[l_ac].nmt12 THEN 
                  CALL cl_err(g_nmt[l_ac].nmt09,'anm-103',0) 
                  NEXT FIELD nmt09  
               END IF  
            END IF    
 
        AFTER FIELD nmt10  
            IF cl_null(g_nmt[l_ac].nmt10) THEN                              
               IF g_aza.aza78 != g_nmt[l_ac].nmt12 THEN 
                  CALL cl_err(g_nmt[l_ac].nmt10,'anm-103',0) 
                  NEXT FIELD nmt10  
               END IF  
            END IF    
#No.FUN-870067--end      
       #TQC-B80113  --begin
        AFTER FIELD nmt13
            IF NOT cl_null(g_nmt[l_ac].nmt13) THEN
               SELECT COUNT(gea01) INTO l_cnt FROM gea_file
                WHERE geaacti = "Y"
                  AND gea01 = g_nmt[l_ac].nmt13
               IF l_cnt <= 0 OR cl_null(l_cnt) THEN
                  CALL cl_err(g_nmt[l_ac].nmt13,'anm-355',0)
                  NEXT FIELD nmt13
               END IF
            END IF
       #TQC-B80113  --end                                                                      
 
        BEFORE DELETE                            #是否取消單身
            IF g_nmt_t.nmt01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                # genero shell add end
{ckp#1}         DELETE FROM nmt_file WHERE nmt01 = g_nmt_t.nmt01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_nmt_t.nmt01,SQLCA.sqlcode,0) #No.FUN-660148
                   CALL cl_err3("del","nmt_file",g_nmt_t.nmt01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"                                             
                CLOSE i080_bcl         
                COMMIT WORK
            END IF
 
 
        ON ROW CHANGE                                                           
          IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_nmt[l_ac].* = g_nmt_t.*
               CLOSE i080_bcl   
               ROLLBACK WORK     
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_nmt[l_ac].nmt01,-263,1)                            
             LET g_nmt[l_ac].* = g_nmt_t.*                                      
          ELSE                                      
             UPDATE nmt_file SET nmt01 = g_nmt[l_ac].nmt01,
                                            nmt02 = g_nmt[l_ac].nmt02,
                                            nmt03 = g_nmt[l_ac].nmt03,
                                            nmt04 = g_nmt[l_ac].nmt04,
                                            nmt05 = g_nmt[l_ac].nmt05,
                                            nmt06 = g_nmt[l_ac].nmt06,
                                            nmt07 = g_nmt[l_ac].nmt07,
                                            nmt08 = g_nmt[l_ac].nmt08,
                                            nmt09 = g_nmt[l_ac].nmt09,
                                            nmt10 = g_nmt[l_ac].nmt10,
                                            nmt11 = g_nmt[l_ac].nmt11,
                                            nmt12 = g_nmt[l_ac].nmt12,
                                            nmt13 = g_nmt[l_ac].nmt13,                 #No.FUN-870067
                                            nmt14 = g_nmt[l_ac].nmt14, #no.FUN-870037
                                            nmtacti = g_nmt[l_ac].nmtacti
                        WHERE nmt01=g_nmt_t.nmt01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nmt[l_ac].nmt01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nmt_file",g_nmt_t.nmt01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nmt[l_ac].* = g_nmt_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i080_bcl         
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_nmt[l_ac].* = g_nmt_t.*
            #FUN-D30032--add--str--
              ELSE
                 CALL g_nmt.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30032--add--end--
              END IF
              EXIT INPUT
           END IF
          #LET g_nmt_t.* = g_nmt[l_ac].*          # 900423
           LET l_ac_t = l_ac    
           CLOSE i080_bcl      
           COMMIT WORK  
           
        #No.FUN-730032--begin--
        ON ACTION CONTROLP
#No.FUN-870067--begin
           CASE
             WHEN INFIELD(nmt13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_gea'
               LET g_qryparam.default1 = g_nmt[l_ac].nmt13
               CALL cl_create_qry() RETURNING g_nmt[l_ac].nmt13
               DISPLAY g_nmt[l_ac].nmt13 TO nmt13 
#No.FUN-870067--end
               
             WHEN INFIELD(nmt06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_too3'
               LET g_qryparam.default1 = g_nmt[l_ac].nmt06
               CALL cl_create_qry() RETURNING g_nmt[l_ac].nmt06
               DISPLAY g_nmt[l_ac].nmt06 TO nmt06 
               
             WHEN INFIELD(nmt07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_top4'
               LET g_qryparam.default1 = g_nmt[l_ac].nmt07
               CALL cl_create_qry() RETURNING g_nmt[l_ac].nmt07
               DISPLAY g_nmt[l_ac].nmt07 TO nmt07
             WHEN INFIELD(nmt08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_toq2'
               LET g_qryparam.default1 = g_nmt[l_ac].nmt08
               CALL cl_create_qry() RETURNING g_nmt[l_ac].nmt08
               DISPLAY g_nmt[l_ac].nmt08 TO nmt08 
             OTHERWISE
                    EXIT CASE  
           END CASE 
        #No.FU-730032--end--
 
        ON ACTION CONTROLN
            CALL i080_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(nmt01) AND l_ac > 1 THEN
                LET g_nmt[l_ac].* = g_nmt[l_ac-1].*
                NEXT FIELD nmt01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i080_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i080_b_askkey()
    CLEAR FORM
   CALL g_nmt.clear()
#   CONSTRUCT g_wc2 ON nmt01,nmt02,nmt03,nmt04,nmt05,nmt06,                       #No.FUN-870067
#                      nmt07,nmt08,nmt09,nmt10,nmt11,nmt12,nmtacti                #No.FUN-870067
#    CONSTRUCT g_wc2 ON nmt01,nmt02,nmt03,nmt12,nmt11,nmt04,nmt05,nmt13,nmt06,     #No.FUN-870067
    CONSTRUCT g_wc2 ON nmt01,nmt02,nmt03,nmt14,nmt12,nmt11,nmt04,nmt05,nmt13,nmt06,     #No.FUN-870067  #no.FUN-870037 add nmt14
                       nmt07,nmt08,nmt09,nmt10,nmtacti                            #No.FUN-870067
            FROM s_nmt[1].nmt01,s_nmt[1].nmt02,s_nmt[1].nmt03,
                 s_nmt[1].nmt14,  #no.FUN-870037
                 s_nmt[1].nmt12,s_nmt[1].nmt11,                                   #No.FUN-870067
#                s_nmt[1].nmt04,s_nmt[1].nmt05,s_nmt[1].nmt06,                    #No.FUN-870067
                 s_nmt[1].nmt04,s_nmt[1].nmt05,s_nmt[1].nmt13,s_nmt[1].nmt06,     #No.FUN-870067
                 s_nmt[1].nmt07,s_nmt[1].nmt08,s_nmt[1].nmt09,
                 s_nmt[1].nmt10,                                                  #No.FUN-870067
#                s_nmt[1].nmt10,s_nmt[1].nmt11,s_nmt[1].nmt12,                    #No.FUN-870067
                 s_nmt[1].nmtacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No.FUN-730032--begin--
      ON ACTION CONTROLP
           CASE
             WHEN INFIELD(nmt06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_too3'
               LET g_qryparam.state = 'c'
               LET g_qryparam.default1 = g_nmt[l_ac].nmt06
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nmt06                
             WHEN INFIELD(nmt07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_top4'
               LET g_qryparam.state = 'c'
               LET g_qryparam.default1 = g_nmt[l_ac].nmt07
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nmt07
             WHEN INFIELD(nmt08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_toq2'
               LET g_qryparam.state = 'c'
               LET g_qryparam.default1 = g_nmt[l_ac].nmt08
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nmt08 
             OTHERWISE
                    EXIT CASE  
           END CASE 
      #No.FUN-730032--end--
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i080_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i080_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
    LET g_sql =
#       "SELECT nmt01,nmt02,nmt03,nmt04,nmt05,nmt06, ",                       #No.FUN-870067
#       "       nmt07,nmt08,nmt09,nmt10,nmt11,nmt12,nmtacti",                 #No.FUN-870067
#        "SELECT nmt01,nmt02,nmt03,nmt12,nmt11,nmt04,nmt05,nmt13,nmt06, ",     #No.FUN-870067
        "SELECT nmt01,nmt02,nmt03,nmt14,nmt12,nmt11,nmt04,nmt05,nmt13,nmt06, ",     #No.FUN-870067  #no.FUN-870037 add nmt14
        "       nmt07,nmt08,nmt09,nmt10,nmtacti",
        " FROM nmt_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i080_pb FROM g_sql
    DECLARE nmt_curs CURSOR FOR i080_pb
 
    CALL g_nmt.clear()
    
    LET g_cnt = 1
    MESSAGE "Seraching!" 
    FOREACH nmt_curs INTO g_nmt[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    CALL g_nmt.deleteElement(g_cnt)                                   
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i080_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmt TO s_nmt.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
                                                                                
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY #MOD-590109 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i080_out()
    DEFINE
        l_nmt           RECORD LIKE nmt_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#      CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    #LET l_name = 'anmi080.out'   #FUN-7B0095
    #CALL cl_outnam('anmi080') RETURNING l_name   #FUN-7B0095
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM nmt_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
#-----FUN-7B0095---------
#   PREPARE i080_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i080_co CURSOR FOR i080_p1
#
#   #No.FUN-730032--begin--   
#   IF g_aza.aza73 = 'N' THEN 
#      LET g_zaa[35].zaa06 = 'Y'
#      LET g_zaa[36].zaa06 = 'Y'
#      LET g_zaa[37].zaa06 = 'Y'
#      LET g_zaa[38].zaa06 = 'Y'
#      LET g_zaa[39].zaa06 = 'Y'
#      LET g_zaa[40].zaa06 = 'Y'
#      LET g_zaa[41].zaa06 = 'Y'
#      LET g_zaa[42].zaa06 = 'Y'
#      LET g_zaa[43].zaa06 = 'Y'
#   ELSE
# 	   LET g_zaa[35].zaa06 = 'N'
# 	   LET g_zaa[36].zaa06 = 'N'
# 	   LET g_zaa[37].zaa06 = 'N'
# 	   LET g_zaa[38].zaa06 = 'N'
# 	   LET g_zaa[39].zaa06 = 'N'
# 	   LET g_zaa[40].zaa06 = 'N'
# 	   LET g_zaa[41].zaa06 = 'N'
# 	   LET g_zaa[42].zaa06 = 'N'
# 	   LET g_zaa[43].zaa06 = 'N'
#   END IF 	
#   CALL cl_prt_pos_len()
#   #No.FUN-730032--end--
 
#   START REPORT i080_rep TO l_name
 
#   FOREACH i080_co INTO l_nmt.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i080_rep(l_nmt.*)
#   END FOREACH
 
#   FINISH REPORT i080_rep
 
#   CLOSE i080_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
 
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
    IF g_zz05='Y' THEN 
#       CALL cl_wcchp(g_wc2,'nmt01,nmt02,nmt03,nmt04,nmt05,nmt06,nmt07,nmt08,nmt09,nmt10,nmt11,nmt12,nmtacti')           #No.FUN-870067
#        CALL cl_wcchp(g_wc2,'nmt01,nmt02,nmt03,nmt12,nmt11,nmt04,nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmtacti')     #No.FUN-870067
        CALL cl_wcchp(g_wc2,'nmt01,nmt02,nmt03,nmt14,nmt12,nmt11,nmt04,nmt05,nmt13,nmt06,nmt07,nmt08,nmt09,nmt10,nmtacti')     #No.FUN-870067  #NO.FUN-870037 add nmt14
        RETURNING g_wc2_1
    END IF
    LET g_str=g_wc2_1
 
    IF g_aza.aza73 = 'N' THEN 
       CALL cl_prt_cs1("anmi080","anmi080",g_sql,g_str)
    ELSE
       CALL cl_prt_cs1("anmi080","anmi080_1",g_sql,g_str)
    END IF
#-----END FUN-7B0095-----
END FUNCTION
 
#-----FUN-7B0095---------
#REPORT i080_rep(sr)
#    DEFINE l_trailer_sw    LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
#    DEFINE sr              RECORD LIKE nmt_file.*
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.nmt01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]     #No.FUN-730032
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            IF sr.nmtacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
#            PRINT COLUMN g_c[32],sr.nmt01,
#                  COLUMN g_c[33],sr.nmt02,
#                  COLUMN g_c[34],sr.nmt03 USING '#######&' ,  #No.TQC-5C0051
#                  COLUMN g_c[35],sr.nmt04 CLIPPED,            #No.FUN-730032
#                  COLUMN g_c[36],sr.nmt05 CLIPPED,            #No.FUN-730032
#                  COLUMN g_c[37],sr.nmt06 CLIPPED,            #No.FUN-730032
#                  COLUMN g_c[38],sr.nmt07 CLIPPED,            #No.FUN-730032
#                  COLUMN g_c[39],sr.nmt08 CLIPPED,            #No.FUN-730032
#                  COLUMN g_c[40],sr.nmt09 CLIPPED,            #No.FUN-730032
#                  COLUMN g_c[41],sr.nmt10 CLIPPED,            #No.FUN-730032
#                  COLUMN g_c[42],sr.nmt11 CLIPPED,            #No.FUN-730032
#                  COLUMN g_c[43],sr.nmt12 CLIPPED             #No.FUN-730032 
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#-----END FUN-7B0095-----
 
#No.FUN-570108 --start                                                          
FUNCTION i080_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("nmt01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i080_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("nmt01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end               
