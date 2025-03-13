# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi130.4gl
# Descriptions...: 銷售系統包裝方式維護作業
# Date & Author..: 94/12/14 by Nick
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-510097 05/01/13 By ching   QBE錯誤調整
# Modify.........: No.FUN-4C0099 05/02/15 By kim 報表轉XML功能
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.MOD-560199 05/08/31 By kim obe24欄位5碼放大為10碼
# Modify.........: No.MOD-5A0266 05/11/01 By Sarah obe24計算完後,加上DISPLAY讓正確數據顯示在畫面上
# Modify.........: No.FUN-610078 06/01/18 By ice 新增攔位obe291,obe292,obe293,obe30
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: NO.FUN-840020 08/04/10 By zhaijie 報表輸出改為CR
# Modify.........: No.TQC-970129 09/07/15 By lilingyu 1."內包裝單位,外包裝單位"沒有控管為正確的已存在于單位資料檔內的單位,錄入任意值沒有控管
# ....................................................2."內包裝含產品數量,內包裝重量"等欄位沒有控管負數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910088 11/11/15 By lixh1 增加數量欄位小數取位
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.FUN-C20048 12/02/10 By fengrui 數量欄位小數取位處理
# Modify.........: No.TQC-C20183 12/02/16 By fengrui 數量欄位小數取位處理
# Modify.........: No.FUN-D30089 13/03/26 By Elise 開放obe11與obe21開窗查詢
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_obe       DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                obe01           LIKE obe_file.obe01,  
                obe02           LIKE obe_file.obe02, 
		obe28		LIKE obe_file.obe28,
		obe11		LIKE obe_file.obe11,
		obe12		LIKE obe_file.obe12,
		obe13		LIKE obe_file.obe13,
		obe21		LIKE obe_file.obe21,
		obe22		LIKE obe_file.obe22,
		obe23		LIKE obe_file.obe23,
		obe251		LIKE obe_file.obe251,
		obe252		LIKE obe_file.obe252,
		obe253		LIKE obe_file.obe253,
		obe24		LIKE obe_file.obe24,
		obe26		LIKE obe_file.obe26,
                #No.FUN-610078 --start--
		obe291		LIKE obe_file.obe291,
		obe292		LIKE obe_file.obe292,
		obe293		LIKE obe_file.obe293,
		obe30		LIKE obe_file.obe30
                #No.FUN-610078 --end--
                END RECORD,
    g_obe_t     RECORD                 #程式變數 (舊值)
                obe01           LIKE obe_file.obe01,  
                obe02           LIKE obe_file.obe02, 
		obe28		LIKE obe_file.obe28,
		obe11		LIKE obe_file.obe11,
		obe12		LIKE obe_file.obe12,
		obe13		LIKE obe_file.obe13,
		obe21		LIKE obe_file.obe21,
		obe22		LIKE obe_file.obe22,
		obe23		LIKE obe_file.obe23,
		obe251		LIKE obe_file.obe251,
		obe252		LIKE obe_file.obe252,
		obe253		LIKE obe_file.obe253,
		obe24		LIKE obe_file.obe24,
		obe26		LIKE obe_file.obe26,
                #No.FUN-610078 --start--
		obe291		LIKE obe_file.obe291,
		obe292		LIKE obe_file.obe292,
		obe293		LIKE obe_file.obe293,
		obe30		LIKE obe_file.obe30
                #No.FUN-610078 --end--
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,            #單身筆數               #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT    #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE   g_forupd_sql  STRING   #SELECT ... FOR UPDATE SQL  
DEFINE   g_cnt         LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose       #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109            #No.FUN-680137 SMALLINT
#NO.FUN-840020---start---
DEFINE l_table        STRING
DEFINE g_str          STRING
#NO.FUN-840020---end----
DEFINE g_obe11_t      LIKE obe_file.obe11    #FUN-910088 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET p_row = 3 LET p_col = 2
#NO.FUN-840020---start---
   LET g_sql = "obe01.obe_file.obe01,",
               "obe02.obe_file.obe02,",
               "obe11.obe_file.obe11,",
               "obe12.obe_file.obe12,",
               "obe13.obe_file.obe13,",
               "obe21.obe_file.obe21,",
               "obe22.obe_file.obe22,",
               "obe23.obe_file.obe23,",
               "obe24.obe_file.obe24,",
               "obe26.obe_file.obe26,",
               "obe28.obe_file.obe28,",
               "obe30.obe_file.obe30,",
               "obe251.obe_file.obe251,",
               "obe252.obe_file.obe252,",
               "obe253.obe_file.obe253,",
               "obe291.obe_file.obe291,",
               "obe292.obe_file.obe292,",
               "obe293.obe_file.obe293"
   LET l_table = cl_prt_temptable('axmi130',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF
#NO.FUN-840020---end----
    OPEN WINDOW i130_w AT p_row,p_col WITH FORM "axm/42f/axmi130"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
    LET g_wc2 = '1=1' CALL i130_b_fill(g_wc2)
    CALL i130_menu()
    CLOSE WINDOW i130_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i130_menu()
 
   WHILE TRUE
      CALL i130_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i130_q() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i130_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i130_out() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_obe),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i130_q()
   CALL i130_b_askkey()
END FUNCTION
 
FUNCTION i130_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680137 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680137 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否         #No.FUN-680137 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態           #No.FUN-680137 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否           #No.FUN-680137 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否           #No.FUN-680137 SMALLINT
DEFINE l_count     LIKE type_file.num5                 #TQC-970129
DEFINE l_case      STRING                                                  #No.FUN-910088
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT obe01,obe02,obe28,obe11,obe12,obe13,obe21,obe22,obe23, ",
                      "       obe251,obe252,obe253,obe24,obe26,obe291,obe292,obe293,obe30 ",  #No.FUN-610078 
                      "  FROM obe_file WHERE obe01=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i130_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_obe WITHOUT DEFAULTS FROM s_obe.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_obe_t.* = g_obe[l_ac].*  #BACKUP
            LET g_obe11_t = g_obe[l_ac].obe11   #FUN-910088 
 
            #No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i130_set_entry_b(p_cmd)                                                                                         
            CALL i130_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
            #No.FUN-570109 --end--     
 
            BEGIN WORK
 
            OPEN i130_bcl USING g_obe_t.obe01
            IF STATUS THEN
               CALL cl_err("OPEN i130_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i130_bcl INTO g_obe[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_obe_t.obe01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO obe_file( obe01,obe02,obe11,obe12,
                               obe13, obe21 , obe22 , obe23 , 
                               obe24, obe251, obe252, obe253, 
                               obe26, obe28,obe291,obe292,obe293,obe30)   #No.FUN-610078
                      VALUES ( g_obe[l_ac].obe01, g_obe[l_ac].obe02, 
                               g_obe[l_ac].obe11, g_obe[l_ac].obe12, 
                               g_obe[l_ac].obe13, g_obe[l_ac].obe21, 
                               g_obe[l_ac].obe22, g_obe[l_ac].obe23, 
                               g_obe[l_ac].obe24, g_obe[l_ac].obe251, 
                               g_obe[l_ac].obe252,g_obe[l_ac].obe253, 
                               g_obe[l_ac].obe26, g_obe[l_ac].obe28,
                               g_obe[l_ac].obe291,g_obe[l_ac].obe292,  #No.FUN-610078
                               g_obe[l_ac].obe293,g_obe[l_ac].obe30)   #No.FUN-610078
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_obe[l_ac].obe01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","obe_file",g_obe[l_ac].obe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         #No.FUN-570109 --start--                                                                                                            
         LET g_before_input_done = FALSE                                                                                      
         CALL i130_set_entry_b(p_cmd)                                                                                         
         CALL i130_set_no_entry_b(p_cmd)                                                                                      
         LET g_before_input_done = TRUE                                                                                       
         #No.FUN-570109 --end--     
         INITIALIZE g_obe[l_ac].* TO NULL      #900423
         LET g_obe_t.* = g_obe[l_ac].*         #新輸入資料
         LET g_obe11_t = NULL   #FUN-910088 
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD obe01
 
      AFTER FIELD obe01                        #check 編號是否重複
         IF g_obe[l_ac].obe01 IS NOT NULL THEN 
            IF g_obe[l_ac].obe01 != g_obe_t.obe01 OR
              (g_obe[l_ac].obe01 IS NOT NULL AND g_obe_t.obe01 IS NULL) THEN
               SELECT count(*) INTO l_n FROM obe_file
                WHERE obe01 = g_obe[l_ac].obe01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_obe[l_ac].obe01 = g_obe_t.obe01
                  NEXT FIELD obe01
               END IF
            END IF
         END IF
 
#TQC-970129 --BEGIN--
     AFTER FIELD obe11
       IF NOT cl_null(g_obe[l_ac].obe11) THEN 
          SELECT COUNT(*) INTO l_count FROM gfe_file
           WHERE gfe01 = g_obe[l_ac].obe11
          IF l_count < 1 THEN 
             CALL cl_err('','axm-131',0)
             NEXT FIELD obe11
          END IF  
         #TQC-C20183--add--str--
         IF NOT cl_null(g_obe[l_ac].obe11) AND NOT cl_null(g_obe[l_ac].obe24) THEN
            IF cl_null(g_obe_t.obe24) OR cl_null(g_obe11_t) OR g_obe_t.obe24 != g_obe[l_ac].obe24
               OR g_obe11_t != g_obe[l_ac].obe11 THEN
               LET g_obe[l_ac].obe24=s_digqty(g_obe[l_ac].obe24,g_obe[l_ac].obe11)
               DISPLAY BY NAME g_obe[l_ac].obe24
            END IF 
         END IF   
         #TQC-C20183--add--end--
         #FUN-910088 ----------Begin-----------
          IF NOT cl_null(g_obe[l_ac].obe12) AND g_obe[l_ac].obe12<>0 THEN #FUN-C20048 add
             IF NOT i130_obe12_check() THEN
                #LET l_case = "obe12"                                     #TQC-C20183 mark
                LET g_obe11_t = g_obe[l_ac].obe11                         #TQC-C20183 add
                NEXT FIELD obe12                                          #TQC-C20183 add
             END IF                                                       #FUN-C20048 add
          END IF
          LET g_obe11_t = g_obe[l_ac].obe11                               #TQC-C20183 add 
          #TQC-C20183--mark--str--
          #IF NOT i130_obe24_check() THEN 
          #   LET l_case = "obe24"
          #END IF     
          #LET g_obe11_t = g_obe[l_ac].obe11  
          #CASE l_case
          #   WHEN "obe12" NEXT FIELD obe12
          #   WHEN "obe24" NEXT FIELD oeb24
          #END CASE 
          #TQC-C20183--mark--end--

         #FUN-910088 ----------End-------------          
       END IF 
       
     AFTER FIELD obe21
       IF NOT cl_null(g_obe[l_ac].obe21) THEN 
          SELECT COUNT(*) INTO l_count FROM gfe_file
           WHERE gfe01 = g_obe[l_ac].obe21
          IF l_count < 1 THEN 
             CALL cl_err('','axm-131',0)
             NEXT FIELD obe21
          END IF  
       END IF      
#TQC-970129 --END--
 
      AFTER FIELD obe12
         IF NOT i130_obe12_check() THEN    #FUN-910088
            NEXT FIELD oeb12               #FUN-910088 
         END IF                            #FUN-910088
#FUN-910088 ---------------Begin---mark---------------      
##TQC-970129 --begin--
#         IF g_obe[l_ac].obe12 < 0 THEN 
#            CALL cl_err('','axm-179',0)
#            NEXT FIELD obe12 
#         END IF 
##TQC-970129 --end--         
#         IF cl_null(g_obe[l_ac].obe12) THEN
#            LET g_obe[l_ac].obe12 = 0
#         END IF 
#         #start MOD-5A0266
#         IF NOT cl_null(g_obe[l_ac].obe22) THEN
#            LET g_obe[l_ac].obe24 = g_obe[l_ac].obe12 * g_obe[l_ac].obe22
#            DISPLAY g_obe[l_ac].obe24 TO obe24
#         END IF
#         #end MOD-5A0266
#FUN-910088 ---------------End-----mark---------------


#TQC-970129 --begin--
       AFTER FIELD obe13
         IF g_obe[l_ac].obe13 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe13 
         END IF 
         
       AFTER FIELD obe23
         IF g_obe[l_ac].obe23 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe23 
         END IF   
          
       AFTER FIELD obe24
          #IF NOT i130_obe24_check() THEN NEXT FIELD oeb24 END IF     #FUN-910088  #TQC-C20183
          IF g_obe[l_ac].obe24 < 0 THEN 
             CALL cl_err('','axm-179',0)         
             NEXT FIELD obe24 
          END IF    
#TQC-970129 --end--     
 
      AFTER FIELD obe22
#TQC-970129 --begin--
         IF g_obe[l_ac].obe22 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe22 
         END IF 
#TQC-970129 --end--      
         IF cl_null(g_obe[l_ac].obe22) THEN
            LET g_obe[l_ac].obe22 = 0
         END IF
         LET g_obe[l_ac].obe24 = g_obe[l_ac].obe12 * g_obe[l_ac].obe22
         LET g_obe[l_ac].obe24=s_digqty(g_obe[l_ac].obe24,g_obe[l_ac].obe11)  #FUN-910088
         
         DISPLAY g_obe[l_ac].obe24 TO obe24   #MOD-5A0266
 
      #No.FUN-610078 --start--
      AFTER FIELD obe251
#TQC-970129 --begin--
         IF g_obe[l_ac].obe251 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe251 
         END IF 
#TQC-970129 --end--       
         LET g_obe[l_ac].obe26 = i130_volume(g_obe[l_ac].obe251,g_obe[l_ac].obe252,g_obe[l_ac].obe253)
         DISPLAY g_obe[l_ac].obe26 TO obe26 
 
      AFTER FIELD obe252
#TQC-970129 --begin--
         IF g_obe[l_ac].obe252 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe252 
         END IF 
#TQC-970129 --end--       
         LET g_obe[l_ac].obe26 = i130_volume(g_obe[l_ac].obe251,g_obe[l_ac].obe252,g_obe[l_ac].obe253)
         DISPLAY g_obe[l_ac].obe26 TO obe26 
 
      AFTER FIELD obe253
#TQC-970129 --begin--
         IF g_obe[l_ac].obe253 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe253 
         END IF 
#TQC-970129 --end--       
         LET g_obe[l_ac].obe26 = i130_volume(g_obe[l_ac].obe251,g_obe[l_ac].obe252,g_obe[l_ac].obe253)
         DISPLAY g_obe[l_ac].obe26 TO obe26 
 
      AFTER FIELD obe26
#TQC-970129 --begin--
         IF g_obe[l_ac].obe26 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe26 
         END IF 
#TQC-970129 --end--        
         IF cl_null(g_obe[l_ac].obe26) AND NOT cl_null(g_obe[l_ac].obe251)
            AND NOT cl_null(g_obe[l_ac].obe251) AND NOT cl_null(g_obe[l_ac].obe252)  THEN
            LET g_obe[l_ac].obe26 = g_obe[l_ac].obe251 * g_obe[l_ac].obe252*g_obe[l_ac].obe253 
            DISPLAY g_obe[l_ac].obe26 TO obe26 
         END IF
 
      AFTER FIELD obe291
#TQC-970129 --begin--
         IF g_obe[l_ac].obe291 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe291 
         END IF 
#TQC-970129 --end--        
         LET g_obe[l_ac].obe30 = i130_volume(g_obe[l_ac].obe291,g_obe[l_ac].obe292,g_obe[l_ac].obe293)
         DISPLAY g_obe[l_ac].obe30 TO obe30
 
      AFTER FIELD obe292
#TQC-970129 --begin--
         IF g_obe[l_ac].obe292 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe292 
         END IF 
#TQC-970129 --end--       
         LET g_obe[l_ac].obe30 = i130_volume(g_obe[l_ac].obe291,g_obe[l_ac].obe292,g_obe[l_ac].obe293)
         DISPLAY g_obe[l_ac].obe30 TO obe30
 
      AFTER FIELD obe293
#TQC-970129 --begin--
         IF g_obe[l_ac].obe293 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe293 
         END IF 
#TQC-970129 --end--        
         LET g_obe[l_ac].obe30 = i130_volume(g_obe[l_ac].obe291,g_obe[l_ac].obe292,g_obe[l_ac].obe293)
         DISPLAY g_obe[l_ac].obe30 TO obe30
 
      AFTER FIELD obe30
#TQC-970129 --begin--
         IF g_obe[l_ac].obe30 < 0 THEN 
            CALL cl_err('','axm-179',0)         
            NEXT FIELD obe30 
         END IF 
#TQC-970129 --end--        
         IF cl_null(g_obe[l_ac].obe30) AND NOT cl_null(g_obe[l_ac].obe291)
            AND NOT cl_null(g_obe[l_ac].obe292) AND NOT cl_null(g_obe[l_ac].obe293) THEN
            LET g_obe[l_ac].obe30 = g_obe[l_ac].obe291 * g_obe[l_ac].obe292*g_obe[l_ac].obe293 
            DISPLAY g_obe[l_ac].obe30 TO obe30 
         END IF
      #No.FUN-610078 --end--
			
      BEFORE DELETE                            #是否取消單身
         IF g_obe_t.obe01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
                
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
                
            DELETE FROM obe_file WHERE obe01 = g_obe_t.obe01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_obe_t.obe01,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","obe_file",g_obe_t.obe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i130_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_obe[l_ac].* = g_obe_t.*
            CLOSE i130_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_obe[l_ac].obe01,-263,1)
            LET g_obe[l_ac].* = g_obe_t.*
         ELSE
            UPDATE obe_file SET 
                   obe01=g_obe[l_ac].obe01, obe02=g_obe[l_ac].obe02,
                   obe11=g_obe[l_ac].obe11, obe12=g_obe[l_ac].obe12,
                   obe13=g_obe[l_ac].obe13, obe21=g_obe[l_ac].obe21,
                   obe22=g_obe[l_ac].obe22, obe23=g_obe[l_ac].obe23,
                   obe24=g_obe[l_ac].obe24, obe251=g_obe[l_ac].obe251,
                   obe252=g_obe[l_ac].obe252,obe253=g_obe[l_ac].obe253,
                   obe26=g_obe[l_ac].obe26, obe28=g_obe[l_ac].obe28,
                   obe291=g_obe[l_ac].obe291,obe292=g_obe[l_ac].obe292,   #No.FUN-610078
                   obe293=g_obe[l_ac].obe293,obe30=g_obe[l_ac].obe30     #No.FUN-610078
             WHERE obe01 = g_obe_t.obe01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_obe[l_ac].obe01,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("upd","obe_file",g_obe_t.obe01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
               LET g_obe[l_ac].* = g_obe_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i130_bcl
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_obe[l_ac].* = g_obe_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_obe.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i130_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac    #FUN-D30034 add
         CLOSE i130_bcl
         COMMIT WORK
 
      ON ACTION CONTROLN
         CALL i130_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(obe01) AND l_ac > 1 THEN
            LET g_obe[l_ac].* = g_obe[l_ac-1].*
            NEXT FIELD obe01
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

     #FUN-D30089---add---S
      ON ACTION controlp
         CASE
            WHEN INFIELD(obe11)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_obe_1"   #mark by guanyao160708
                 LET g_qryparam.form ="q_gfe"      #add by guanyao160708
                 CALL cl_create_qry() RETURNING g_obe[l_ac].obe11
                 DISPLAY BY NAME g_obe[l_ac].obe11 
                 NEXT FIELD obe11

            WHEN INFIELD(obe21)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_obe_2"   #mark by guanyao160708
                 LET g_qryparam.form ="q_gfe"      #add by guanyao160708
                 CALL cl_create_qry() RETURNING g_obe[l_ac].obe21
                 DISPLAY BY NAME g_obe[l_ac].obe21
                 NEXT FIELD obe21
         END CASE
     #FUN-D30089---add---E
       
   END INPUT
   CLOSE i130_bcl
   COMMIT WORK
 
END FUNCTION

#FUN-910088 ---------------Begin----add--------------
FUNCTION i130_obe12_check()
   
   IF g_obe[l_ac].obe12 < 0 THEN 
      CALL cl_err('','axm-179',0)
      RETURN FALSE
   END IF 
   IF NOT cl_null(g_obe[l_ac].obe11) AND NOT cl_null(g_obe[l_ac].obe12) THEN
      IF cl_null(g_obe_t.obe12) OR cl_null(g_obe11_t) OR g_obe_t.obe12 != g_obe[l_ac].obe12
         OR g_obe11_t != g_obe[l_ac].obe11 THEN
         LET g_obe[l_ac].obe12=s_digqty(g_obe[l_ac].obe12,g_obe[l_ac].obe11)
         DISPLAY BY NAME g_obe[l_ac].obe12
      END IF 
   END IF          
   IF cl_null(g_obe[l_ac].obe12) THEN
      LET g_obe[l_ac].obe12 = 0
   END IF 
        
   IF NOT cl_null(g_obe[l_ac].obe22) THEN
      LET g_obe[l_ac].obe24 = g_obe[l_ac].obe12 * g_obe[l_ac].obe22
      LET g_obe[l_ac].obe24 = s_digqty(g_obe[l_ac].obe24,g_obe[l_ac].obe11)
      DISPLAY g_obe[l_ac].obe24 TO obe24            
   END IF  
   RETURN TRUE      
END FUNCTION

#TQC-C20183--mark--str--
#FUNCTION i130_obe24_check()
#   IF g_obe[l_ac].obe24 < 0 THEN 
#      CALL cl_err('','axm-179',0)         
#      RETURN FALSE 
#   END IF  
#   IF NOT cl_null(g_obe[l_ac].obe11) AND NOT cl_null(g_obe[l_ac].obe24) THEN
#      IF cl_null(g_obe_t.obe24) OR cl_null(g_obe11_t) OR g_obe_t.obe24 != g_obe[l_ac].obe24
#         OR g_obe11_t != g_obe[l_ac].obe11 THEN
#         LET g_obe[l_ac].obe24=s_digqty(g_obe[l_ac].obe24,g_obe[l_ac].obe11)
#         DISPLAY BY NAME g_obe[l_ac].obe24
#      END IF 
#   END IF   
#   RETURN TRUE     
#END FUNCTION
#TQC-C20183--mark--end--
#FUN-910088 ---------------End------add--------------
 
FUNCTION i130_b_askkey()
    CLEAR FORM
    CALL g_obe.clear()
    CONSTRUCT g_wc2 ON 
                     obe01,obe02,obe28,obe11,obe12,obe13,obe21,  #MOD-510097
                    obe22,obe23,obe251,obe252,obe253,obe24,obe26,
                    obe291,obe292,obe293,obe30                   #No.FUN-610078
               FROM s_obe[1].obe01,s_obe[1].obe02,s_obe[1].obe28,
                    s_obe[1].obe11,s_obe[1].obe12,s_obe[1].obe13,
                    s_obe[1].obe21,s_obe[1].obe22,s_obe[1].obe23,
                    s_obe[1].obe251,s_obe[1].obe252,s_obe[1].obe253,
                    s_obe[1].obe24,s_obe[1].obe26,s_obe[1].obe291,   #No.FUN-610078
                    s_obe[1].obe292,s_obe[1].obe293,s_obe[1].obe30   #No.FUN-610078
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
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN

     #FUN-D30089---add---S
      ON ACTION controlp
         CASE
            WHEN INFIELD(obe11)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_obe_1"   #mark by guayao160708
                 LET g_qryparam.form ="q_gfe"      #add by guanyao160708
                 CALL cl_create_qry() RETURNING g_obe[l_ac].obe11
                 DISPLAY BY NAME g_obe[l_ac].obe11
                 NEXT FIELD obe11

            WHEN INFIELD(obe21)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_obe_2"   #mark by guanyao160708
                 LET g_qryparam.form ="q_gfe"      #add by guanyao160708
                 CALL cl_create_qry() RETURNING g_obe[l_ac].obe21
                 DISPLAY BY NAME g_obe[l_ac].obe21
                 NEXT FIELD obe21
         END CASE
     #FUN-D30089---add---E
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
    CALL i130_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i130_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql = "SELECT obe01,obe02,obe28,obe11,obe12,obe13,obe21,",
                "       obe22,obe23,obe251,obe252,obe253,obe24,obe26, ",  
                "       obe291,obe292,obe293,obe30 ",   #No.FUN-610078
                " FROM obe_file",
                " WHERE ",p_wc2 CLIPPED," ",                  #單身
                " ORDER BY obe01"                               #No.FUN-610078
    PREPARE i130_pb FROM g_sql
    DECLARE obe_curs CURSOR FOR i130_pb
 
    CALL g_obe.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH obe_curs INTO g_obe[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_obe.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i130_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obe TO s_obe.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         LET l_ac = 1
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
 
   
    ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_out()
    DEFINE
        l_obe           RECORD LIKE obe_file.*,
        l_i             LIKE type_file.num5,                  #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #No.FUN-680137 VARCHAR(40)
    CALL cl_del_data(l_table)                                 #NO.FUN-840020
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmi130' #NO.FUN-840020   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0) RETURN END IF
#      CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
#    CALL cl_outnam('axmi130') RETURNING l_name             #NO.FUN-840020
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM obe_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i130_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i130_co                           # CURSOR
        CURSOR FOR i130_p1
 
#    START REPORT i130_rep TO l_name          #NO.FUN-840020
 
    FOREACH i130_co INTO l_obe.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
            END IF
#        OUTPUT TO REPORT i130_rep(l_obe.*)   #NO.FUN-840020
#NO.FUN-840020----start---
       EXECUTE insert_prep USING
         l_obe.obe01,l_obe.obe02,l_obe.obe11,l_obe.obe12,l_obe.obe13,
         l_obe.obe21,l_obe.obe22,l_obe.obe23,l_obe.obe24,l_obe.obe26,
         l_obe.obe28,l_obe.obe30,l_obe.obe251,l_obe.obe252,l_obe.obe253,
         l_obe.obe291,l_obe.obe292,l_obe.obe293
#NO.FUN-840020----end---
    END FOREACH
 
#    FINISH REPORT i130_rep                   #NO.FUN-840020
#NO.FUN-840020---start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc2,'obe01,obe02,obe28,obe11,obe12,obe13,obe21,
                            obe22,obe23,obe251,obe252,obe253,obe24,obe26,
                            obe291,obe292,obe293,obe30')
           RETURNING g_wc2
     END IF
     LET g_str = g_wc2
     CALL cl_prt_cs3('axmi130','axmi130',g_sql,g_str) 
#NO.FUN-840020---end----
    CLOSE i130_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)        #NO.FUN-840020
END FUNCTION
#NO.FUN-840020---start--mark--
#REPORT i130_rep(sr)
#    DEFINE
#        l_trailer_sw   LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(01)
#        sr RECORD LIKE obe_file.*,
#        l_x             LIKE aaf_file.aaf03,         #No.FUN-680137 VARCHAR(40)
#        l_i,i           LIKE type_file.num5          #No.FUN-680137 SMALLINT
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.obe01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT 
#            PRINT g_dash
#            #No.FUN-610078 --start--
#            PRINT g_x[31],g_x[32],g_x[33]
#
#            PRINT g_dash1
##           PRINT COLUMN g_c[31],g_dash2[1,g_w[31]+g_w[32]+1],
##                 COLUMN g_c[33],g_dash2[1,g_w[33]],
##                 COLUMN g_c[34],g_dash2[1,g_w[34]+g_w[35]+1]
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            LET l_i = FGL_WIDTH(sr.obe11 CLIPPED)
#            LET l_i = 6 - l_i
#            LET l_x = g_x[10],sr.obe11 CLIPPED,l_i SPACES,g_x[11],
#                      sr.obe291 USING '###.#'
#            IF NOT cl_null(sr.obe291) THEN LET l_x = l_x,' ft' END IF
#            PRINT COLUMN g_c[31],sr.obe01,
#                  COLUMN g_c[32],l_x CLIPPED;
#            LET l_i = FGL_WIDTH(sr.obe21 CLIPPED)
#            LET l_i = 6 - l_i
#            LET l_x = g_x[10],sr.obe21 CLIPPED,l_i SPACES,g_x[11],
#                      sr.obe251 USING '###.#'
#            IF NOT cl_null(sr.obe251) THEN LET l_x = l_x,' ft' END IF
#	    PRINT COLUMN g_c[33],l_x CLIPPED
#            LET l_x = g_x[12],sr.obe12 USING '#####',1 SPACES,g_x[13],
#                      sr.obe292 USING '###.#'
#            IF NOT cl_null(sr.obe292) THEN LET l_x = l_x,' ft' END IF
#	    PRINT COLUMN g_c[31],sr.obe02,
#	          COLUMN g_c[32],l_x CLIPPED;
#            LET l_x = g_x[12],sr.obe22 USING '#####',1 SPACES,g_x[13],
#                      sr.obe252 USING '###.#'
#            IF NOT cl_null(sr.obe252) THEN LET l_x = l_x,' ft' END IF
#	    PRINT COLUMN g_c[33],l_x CLIPPED
#            LET l_x = g_x[15],sr.obe13 USING '###.#',1 SPACES,g_x[16],
#                      sr.obe293 USING '###.#'
#            IF NOT cl_null(sr.obe293) THEN LET l_x = l_x,' ft' END IF
#            PRINT COLUMN g_c[31],sr.obe28,
#	          COLUMN g_c[32],l_x CLIPPED;
#            LET l_x = g_x[15],sr.obe23 USING '###.#',1 SPACES,g_x[16],
#                      sr.obe253 USING '###.#'
#            IF NOT cl_null(sr.obe253) THEN LET l_x = l_x,' ft' END IF
#	    PRINT COLUMN g_c[33],l_x CLIPPED
#	    PRINT COLUMN g_c[31],g_x[9] CLIPPED,cl_numfor(sr.obe24,10,0),
#                  COLUMN g_c[32],g_x[17] CLIPPED,sr.obe30 USING '######.#',
#                  COLUMN g_c[33],g_x[18] CLIPPED,sr.obe26 USING '######.#'
#            #No.FUN-610078 --end--
#
#        ON LAST ROW
#            PRINT g_dash
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#NO.FUN-840020---end--mark--
#No.FUN-570109 --start--                                                                                                            
FUNCTION i130_set_entry_b(p_cmd)                                                                                                    
   DEFINE p_cmd   LIKE type_file.chr1                        #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
      CALL cl_set_comp_entry("obe01",TRUE)                                                                                           
   END IF                                                                                                                            
END FUNCTION                                                                                                                        
 
FUNCTION i130_set_no_entry_b(p_cmd)                                                                                                 
   DEFINE p_cmd   LIKE type_file.chr1                        #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
      CALL cl_set_comp_entry("obe01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--    
 
#No.FUN-610078 --start--
#計算材積
FUNCTION i130_volume(l,w,h)
   DEFINE l,w,h      LIKE type_file.num15_3,   #LIKE cqk_file.cqk14,   #長寬高       #No.FUN-680137   #TQC-B90211
          l_volume   LIKE crd_file.crd12    #材積         #No.FUN-680137
 
   LET l_volume = NULL
   LET l_volume = l * w * h
   RETURN l_volume 
END FUNCTION
#No.FUN-610078 --end--
