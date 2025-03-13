# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi401.4gl
# Descriptions...: 編碼性質說明
# Date & Author..: 03/06/25 By Carrier
# Modify.........: No.A086 03/11/26 By ching append
#                  MOD-470515 04/10/06 Nicola 加入"相關文件"功能
#                  FUN-4B0020 04/11/03 Nicola 加入"轉EXCEL"功能
#                  FUN-510027 05/01/14 pengu 報表轉XML
#                  MOD-520094 05/03/03 alex 修正查核欄位用 table (改為 gat)
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制  
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-590001 05/10/26 By Nicola 先輸入"類別"再自動帶出"檔案名稱 / 索引值" default 值
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-750041 07/05/15 By Lynn 打印無效資料，報表中未體現出
# Modify.........: No.FUN-780056 07/06/29 By mike 報表格式修改為p_query
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-7C0084 08/01/23 By Mandy 欄位"檔案名稱","索引值",根據類別給固定值後,即不能修改
# Modify.........: No.MOD-840640 08/07/09 By Pengu 將程式中的faj01替換成faj02
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50011 10/06/08 By Yang  geh04增加選項‘7 商品條碼‘，並為其自動編號
# Modify.........: No.FUN-A70084 10/07/27 By lutingting 串gat_file改串zta_file 
# Modify.........: No.FUN-B30202 11/03/31 By huangtao geh04增加選項‘會員編號(流通)'
# Modify.........: No.FUN-B90056 11/09/13 By baogc geh04增加選項'9:場地編號(流通)','A:攤位編號(流通)','B:商戶編號(流通)'
# Modify.........: No.TQC-C20124 12/02/14 By fanbj 選擇類型更新表名，‘9:場地編號(流通)lmd_file','A:攤位編號(流通) lmf_file','B:商戶編號(流通) lne_file'
# Modify.........: No.TQC-C30130 12/03/07 By baogc 擇類型更新表名，‘9:場地編號(流通)lia_file','A:攤位編號(流通) lib_file'
# Modify.........: No.FUN-D10021 13/01/07 By dongsz geh04增加選項'C:倉庫編號(流通)'
# Modify.........: No.DEV-D30026 13/03/15 By Nina GP5.3 追版:DEV-CA0005、DEV-CB0002、DEV-D10003為GP5.25 的單號
# Modify.........: No.DEV-D30034 13/03/20 By TSD.JIE
# 1.當類別為"5"or"6"時,詢問是否條碼所使用,若是則檔案名稱(geh03) INSERT："iba_file",索引值(geh05) INSERT："iba01"
# 2.當類別為"F"or"G"時,直接檔案名稱(geh03) INSERT："iba_file",索引值(geh05) INSERT："iba01"
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:DEV-D40015 13/04/12 By Nina 修正geh04等於F、G代入的table

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_geh           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        geh01       LIKE geh_file.geh01,  
        geh02       LIKE geh_file.geh02, 
        geh04       LIKE geh_file.geh04,   #No.FUN-590001
        geh03       LIKE geh_file.geh03,
        geh05       LIKE geh_file.geh05, 
        gehacti     LIKE geh_file.gehacti
                    END RECORD,
    g_geh_t         RECORD                 #程式變數 (舊值)
        geh01       LIKE geh_file.geh01,  
        geh02       LIKE geh_file.geh02, 
        geh04       LIKE geh_file.geh04,   #No.FUN-590001
        geh03       LIKE geh_file.geh03,
        geh05       LIKE geh_file.geh05, 
        gehacti     LIKE geh_file.gehacti
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN        
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110        #No.FUN-680102 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0081
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW i401_w AT p_row,p_col
     WITH FORM "aoo/42f/aooi401"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
 
   CALL i401_b_fill(g_wc2)
 
   CALL i401_menu()
 
   CLOSE WINDOW i401_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
END MAIN
 
FUNCTION i401_menu()
 DEFINE l_cmd LIKE type_file.chr1000                        #No.FUN-780056
 WHILE TRUE
      CALL i401_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i401_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i401_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #CALL i401_out()                                   #No.FUN-780056  
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF      #No.FUN-780056
               LET l_cmd='p_query "aooi401" "',g_wc2 CLIPPED,'"'  #No.FUN-780056  
               CALL cl_cmdrun(l_cmd)                              #No.FUN-780056  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_geh[l_ac].geh01 IS NOT NULL THEN
                  LET g_doc.column1 = "geh01"
                  LET g_doc.value1 = g_geh[l_ac].geh01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_geh),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i401_q()
   CALL i401_b_askkey()
END FUNCTION
 
FUNCTION i401_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102   VARCHAR(1),          #可新增否
    l_allow_delete  LIKE type_file.chr1,           #No.FUN-680102   VARCHAR(1)          #可刪除否
    l_cnt           LIKE type_file.num5            #DEV-D30026 add
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT geh01,geh02,geh04,geh03,geh05,gehacti",   #No.FUN-590001
                       "  FROM geh_file WHERE geh01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i401_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_geh WITHOUT DEFAULTS FROM s_geh.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
       
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          IF g_rec_b >= l_ac THEN
             BEGIN WORK
             LET p_cmd='u'
             LET g_geh_t.* = g_geh[l_ac].*  #BACKUP
#No.FUN-570110 --start                                                          
             LET g_before_input_done = FALSE                                    
             CALL i401_set_entry(p_cmd)                                         
             CALL i401_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                     
#No.FUN-570110 --end         
       
             OPEN i401_bcl USING g_geh_t.geh01
             IF STATUS THEN
                CALL cl_err("OPEN i401_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE 
                FETCH i401_bcl INTO g_geh[l_ac].* 
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_geh_t.geh01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
       
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
#No.FUN-570110 --start                                                          
          LET g_before_input_done = FALSE                                       
          CALL i401_set_entry(p_cmd)                                            
          CALL i401_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
#No.FUN-570110 --end        
          INITIALIZE g_geh[l_ac].* TO NULL      #900423
          LET g_geh[l_ac].gehacti = 'Y'       #Body default
          LET g_geh_t.* = g_geh[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD geh01
       
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i401_bcl
             CANCEL INSERT
          END IF
          INSERT INTO geh_file(geh01,geh02,geh03,geh05,geh04,gehacti,gehoriu,gehorig)
               VALUES(g_geh[l_ac].geh01,g_geh[l_ac].geh02,g_geh[l_ac].geh03,
                      g_geh[l_ac].geh05,g_geh[l_ac].geh04,g_geh[l_ac].gehacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN 
#            CALL cl_err(g_geh[l_ac].geh01,SQLCA.sqlcode,0)   #No.FUN-660131
             CALL cl_err3("ins","geh_file",g_geh[l_ac].geh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
          END IF
       
       AFTER FIELD geh01                        #check 編號是否重複
          IF NOT cl_null(g_geh[l_ac].geh01) THEN
             IF g_geh[l_ac].geh01 != g_geh_t.geh01 OR cl_null(g_geh_t.geh01) THEN
                SELECT count(*) INTO l_n FROM geh_file
                 WHERE geh01 = g_geh[l_ac].geh01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_geh[l_ac].geh01 = g_geh_t.geh01
                   NEXT FIELD geh01
                END IF
             END IF
          END IF
       
       AFTER FIELD geh03
          IF NOT cl_null(g_geh[l_ac].geh03) THEN
 #            #MOD-520094
           #FUN-A70084--mod--str--
           # SELECT COUNT(*) INTO l_n FROM gat_file
           #  WHERE gat01 = g_geh[l_ac].geh03
             SELECT COUNT(*) INTO l_n FROM zta_file 
              WHERE zta01 = g_geh[l_ac].geh03
           #FUN-A70084--mod--end
#            SELECT COUNT(*) INTO l_n FROM zt_file
#             WHERE zt01 = g_geh[l_ac].geh03
             IF l_n = 0 THEN
                CALL cl_err(g_geh[l_ac].geh03,'mfg9180',0)
                NEXT FIELD geh03
             END IF
          END IF
       
       AFTER FIELD geh04
          IF NOT cl_null(g_geh[l_ac].geh04) THEN
             #No:DEV-D30026--add--begin
             #與M-Barcode整合(aza131)='Y'時,類別(geh04)才可以挑選<F or G or H>
             IF (g_aza.aza131 = 'N' OR cl_null(g_aza.aza131)) AND
                g_geh[l_ac].geh04 MATCHES '[FGH]' THEN
                CALL cl_err('','aba-121',0)
                NEXT FIELD geh04
             END IF
             #類別==>D:訂單包裝單,E:交接單,在此並不開放挑選,在此僅佔住此代號,
             #後續透過abai140(訂單包裝單)或交接單(abat630)所產生的條碼,其iba02的值直接給"D" or "E"
             IF g_geh[l_ac].geh04 MATCHES '[DE]' THEN
                CALL cl_err('','aba-177',0)
                NEXT FIELD geh04
             END IF
             #No:DEV-D30026--add--end
   #         IF g_geh[l_ac].geh04 NOT MATCHES '[1-7]' THEN   #No.FUN-810036 #FUN-B30202 mark
   #         IF g_geh[l_ac].geh04 NOT MATCHES '[1-8]' THEN                  #FUN-B30202 add   #FUN-B90056 MARK
             IF g_geh[l_ac].geh04 NOT MATCHES '[1-8FGH]'        #FUN-B90056 ADD    #DEV-D30026-ADD DEF
   #            AND g_geh[l_ac].geh04 NOT MATCHES '[9AB]' THEN  #FUN-B90056 ADD    #FUN-D10021 mark
                AND g_geh[l_ac].geh04 NOT MATCHES '[9ABC]' THEN     #FUN-D10021 add
                NEXT FIELD geh04 
             #-----No.FUN-490001-----
             ELSE
                IF cl_null(g_geh[l_ac].geh03) THEN
                   CASE g_geh[l_ac].geh04
                      WHEN "1"
                         LET g_geh[l_ac].geh03 = "ima_file"
                      WHEN "2"
                         LET g_geh[l_ac].geh03 = "occ_file"
                      WHEN "3"
                         LET g_geh[l_ac].geh03 = "pmc_file"
                      WHEN "4"
                         LET g_geh[l_ac].geh03 = "faj_file"
                      #-----No.FUN-810036-----
                      WHEN "5"
                         LET g_geh[l_ac].geh03 = "rvbs_file"
                      WHEN "6"
                         LET g_geh[l_ac].geh03 = "rvbs_file"
                      #-----No.FUN-810036 END-----
                      WHEN "7"
                         LET g_geh[l_ac].geh03 = "rta_file"   #No.FUN-A50011
                      #FUN-B30202 ---------STA
                      WHEN "8"
                         LET g_geh[l_ac].geh03 = "lpk_file"
                      #FUN-B30202 ---------END
                     #FUN-B90056 Add Begin ---
                      WHEN "9"
                         LET g_geh[l_ac].geh03 = "lia_file"
                      WHEN "A"
                         LET g_geh[l_ac].geh03 = "lib_file"
                      WHEN "B"
                         LET g_geh[l_ac].geh03 = "lne_file"
                     #FUN-B90056 Add End -----
                      WHEN "C"                                #FUN-D10021 add
                         LET g_geh[l_ac].geh03 = "imd_file"   #FUN-D10021 add
                      #DEV-D30026----ADD-----STR---
                      WHEN "D"
                         LET g_geh[l_ac].geh03 = "rvbs_file"
                      WHEN "E"
                         LET g_geh[l_ac].geh03 = "rvbs_file"
                      WHEN "F"
                         LET g_geh[l_ac].geh03 = NULL
                      #DEV-D30026----ADD-----END---
                   END CASE
                END IF
                IF cl_null(g_geh[l_ac].geh05) THEN
                   CASE g_geh[l_ac].geh04
                      WHEN "1"
                         LET g_geh[l_ac].geh05 = "ima01"
                      WHEN "2"
                         LET g_geh[l_ac].geh05 = "occ01"
                      WHEN "3"
                         LET g_geh[l_ac].geh05 = "pmc01"
                      WHEN "4"
                         LET g_geh[l_ac].geh05 = "faj02"     #No.MOD-840640 modify
                      #-----No.FUN-810036-----
                      WHEN "5"
                         LET g_geh[l_ac].geh05 = "rvbs04"
                      WHEN "6"
                         LET g_geh[l_ac].geh05 = "rvbs03"
                      #-----No.FUN-810036 END-----
                      WHEN "7"
                         LET g_geh[l_ac].geh05 = "rta05"     #No.FUN-A50011
                      #FUN-B30202 ---------STA
                      WHEN "8"
                         LET g_geh[l_ac].geh05 = "lpk01"
                      #FUN-B30202 ---------END
                     #FUN-B90056 Add Begin ---
                      WHEN "9"
                         LET g_geh[l_ac].geh05 = "lia04"
                      WHEN "A"
                         LET g_geh[l_ac].geh05 = "lib05"
                      WHEN "B"
                         LET g_geh[l_ac].geh05 = "lne01"
                     #FUN-B90056 Add End -----
                      WHEN "C"                               #FUN-D10021 add
                         LET g_geh[l_ac].geh05 = "imd01"     #FUN-D10021 add
                      #DEV-D30026----ADD-----STR---
                      WHEN "F"
                         LET g_geh[l_ac].geh05 = "rvbs04"
                      WHEN "G"
                         LET g_geh[l_ac].geh05 = "rvbs04"
                      WHEN "H"
                         LET g_geh[l_ac].geh05 = NULL
                      #DEV-D30026----ADD-----END---
                   END CASE
                END IF
                DISPLAY BY NAME g_geh[l_ac].geh03,g_geh[l_ac].geh05
             END IF
             #-----No.FUN-490001 END-----
          END IF
 
       #FUN-7C0084---add---str---
       ON CHANGE geh04
          IF NOT cl_null(g_geh[l_ac].geh04) THEN
      #       IF g_geh[l_ac].geh04 NOT MATCHES '[1-7]' THEN        #FUN-B30202 mark
      #        IF g_geh[l_ac].geh04 NOT MATCHES '[1-8]' THEN        #FUN-B30202 add    #TQC-C20124 mark
             IF g_geh[l_ac].geh04 NOT MATCHES '[1-BFGH]' THEN         #TQC-C20124  add  #DEV-D30026----ADD DEF
                NEXT FIELD geh04 
             ELSE
                 CASE g_geh[l_ac].geh04
                    WHEN "1"
                       LET g_geh[l_ac].geh03 = "ima_file"
                    WHEN "2"
                       LET g_geh[l_ac].geh03 = "occ_file"
                    WHEN "3"
                       LET g_geh[l_ac].geh03 = "pmc_file"
                    WHEN "4"
                       LET g_geh[l_ac].geh03 = "faj_file"
                    WHEN "5"
                       LET g_geh[l_ac].geh03 = "rvbs_file"
                    WHEN "6"
                       LET g_geh[l_ac].geh03 = "rvbs_file"
                    WHEN "7"
                       LET g_geh[l_ac].geh03 = "rta_file"   #No.FUN-A50011
                    #FUN-B30202 ------STA
                    WHEN "8"
                       LET g_geh[l_ac].geh03 = "lpk_file" 
                    #FUN-B30202 ------END
                    #TQC-C20124--start add---------------
                    WHEN "9"
                      #LET g_geh[l_ac].geh03 = "lmd_file" #TQC-C30130 Mark
                       LET g_geh[l_ac].geh03 = "lia_file" #TQC-C30130 Add
                    WHEN "A"
                      #LET g_geh[l_ac].geh03 = "lmf_file" #TQC-C30130 Mark
                       LET g_geh[l_ac].geh03 = "lib_file" #TQC-C30130 Add
                    WHEN "B"
                       LET g_geh[l_ac].geh03 = "lne_file"
                    #TQC-C20124--end add-----------------
                    #DEV-D30026----ADD-----STR---
                      WHEN "F"
                        #LET g_geh[l_ac].geh03 = "rvbs_file" #DEV-D30034 mark
                        #LET g_geh[l_ac].geh03 = "lba_file"  #DEV-D30034 add  #DEV-D40015 mark
                         LET g_geh[l_ac].geh03 = "iba_file"  #DEV-D40015 add
                      WHEN "G"
                        #LET g_geh[l_ac].geh03 = "rvbs_file" #DEV-D30034 mrak
                        #LET g_geh[l_ac].geh03 = "lba_file"  #DEV-D30034 add  #DEV-D40015 mark
                         LET g_geh[l_ac].geh03 = "iba_file"  #DEV-D40015 add
                      WHEN "H"
                         LET g_geh[l_ac].geh03 = NULL
                    #DEV-D30026----ADD-----END---
                 END CASE
                 CASE g_geh[l_ac].geh04
                    WHEN "1"
                       LET g_geh[l_ac].geh05 = "ima01"
                    WHEN "2"
                       LET g_geh[l_ac].geh05 = "occ01"
                    WHEN "3"
                       LET g_geh[l_ac].geh05 = "pmc01"
                    WHEN "4"
                       LET g_geh[l_ac].geh05 = "faj02"     #No.MOD-840640 modify
                    WHEN "5"
                       LET g_geh[l_ac].geh05 = "rvbs04"
                    WHEN "6"
                       LET g_geh[l_ac].geh05 = "rvbs03"
                    WHEN "7"
                       LET g_geh[l_ac].geh05 = "rta05"     #No.FUN-A50011
                    #FUN-B30202 ------STA
                    WHEN "8"
                       LET g_geh[l_ac].geh05 = "lpk01"
                    #FUN-B30202 ------END
                    #TQC-C20124--start add---------------
                    WHEN "9"
                      #LET g_geh[l_ac].geh05 = "lmd01" #TQC-C30130 Mark
                       LET g_geh[l_ac].geh05 = "lia04" #TQC-C30130 Add
                    WHEN "A"
                      #LET g_geh[l_ac].geh05 = "lmf01" #TQC-C30130 Mark
                       LET g_geh[l_ac].geh05 = "lib05" #TQC-C30130 Add
                    WHEN "B"      
                       LET g_geh[l_ac].geh05 = "lne01"
                    #TQC-C20124--end add----------------- 
                    #DEV-D30026----ADD-----STR---
                      WHEN "F"
                        #LET g_geh[l_ac].geh05 = "rvbs04" #DEV-D30034 mark
                         LET g_geh[l_ac].geh05 = "iba01"  #DEV-D30034 add
                      WHEN "G"
                        #LET g_geh[l_ac].geh05 = "rvbs04" #DEV-D30034 mark
                         LET g_geh[l_ac].geh05 = "iba01"  #DEV-D30034 add
                      WHEN "H"
                         LET g_geh[l_ac].geh05 = NULL
                   #DEV-D30026----ADD-----END---
                 END CASE
                 #DEV-D30034--begin
                 IF g_aza.aza131 = 'Y' AND g_geh[l_ac].geh04 MATCHES '[56]' THEN
                    IF cl_confirm('aba-170') THEN
                       LET g_geh[l_ac].geh03 = "iba_file"
                       LET g_geh[l_ac].geh05 = "iba01"
                    END IF
                 END IF
                 #DEV-D30034--end
                DISPLAY BY NAME g_geh[l_ac].geh03,g_geh[l_ac].geh05
             END IF
          END IF
       #FUN-7C0084---add---end---
       
       AFTER FIELD gehacti
          IF NOT cl_null(g_geh[l_ac].gehacti) THEN 
             IF g_geh[l_ac].gehacti NOT MATCHES '[YN]' THEN
                LET g_geh[l_ac].gehacti = g_geh_t.gehacti
                CALL cl_err('','mfg1002',0)
                NEXT FIELD gehacti
             END IF
          END IF
       
       BEFORE DELETE                            #是否取消單身
          IF NOT cl_null(g_geh_t.geh01) THEN
            #DEV-D30026 add str-------------
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt FROM gei_file
             WHERE gei03 = g_geh[l_ac].geh01
             IF l_cnt > 0 THEN
                CALL cl_err('','aba-133',1)
                CANCEL DELETE
             ELSE
            #DEV-D30026 add end-------------
 
                IF g_cnt = 0 THEN 
                   IF NOT cl_delete() THEN
                      CANCEL DELETE
                   END IF
                   INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                   LET g_doc.column1 = "geh01"               #No.FUN-9B0098 10/02/24
                   LET g_doc.value1 = g_geh[l_ac].geh01      #No.FUN-9B0098 10/02/24
                   CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                   IF l_lock_sw = "Y" THEN 
                      CALL cl_err("", -263, 1) 
                      CANCEL DELETE 
                   END IF 
                   DELETE FROM geh_file WHERE geh01 = g_geh_t.geh01
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_geh_t.geh01,SQLCA.sqlcode,0)   #No.FUN-660131
                      CALL cl_err3("del","geh_file",g_geh_t.geh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                      EXIT INPUT
                   END IF
                   LET g_rec_b=g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                   EXIT INPUT 
                END IF 
             END IF                #DEV-D30026 add
          END IF
       
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_geh[l_ac].* = g_geh_t.*
             CLOSE i401_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_geh[l_ac].geh01,-263,0)
             LET g_geh[l_ac].* = g_geh_t.*
          ELSE
             UPDATE geh_file 
                 SET geh01=g_geh[l_ac].geh01,geh02=g_geh[l_ac].geh02,
                     geh03=g_geh[l_ac].geh03,geh05=g_geh[l_ac].geh05,
                     geh04=g_geh[l_ac].geh04,gehacti=g_geh[l_ac].gehacti 
              WHERE geh01 = g_geh_t.geh01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_geh[l_ac].geh01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("upd","geh_file",g_geh_t.geh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                LET g_geh[l_ac].* = g_geh_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
       
       AFTER ROW
          LET l_ac = ARR_CURR()         # 新增
          #LET l_ac_t = l_ac            # 新增 #FUN-D40030 
       
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_geh[l_ac].* = g_geh_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_geh.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i401_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          #LET l_ac_t = l_ac  #FUN-D40030 
          CLOSE i401_bcl            # 新增
          COMMIT WORK
       
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(geh01) AND l_ac > 1 THEN
             LET g_geh[l_ac].* = g_geh[l_ac-1].*
             NEXT FIELD geh01
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
 
    CLOSE i401_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i401_b_askkey()
 
   CLEAR FORM
   CALL g_geh.clear()
 
   CONSTRUCT g_wc2 ON geh01,geh02,geh04,geh03,geh05,gehacti   #No.FUN-590001
        FROM s_geh[1].geh01,s_geh[1].geh02,s_geh[1].geh04,    #No.FUN-590001
             s_geh[1].geh03,s_geh[1].geh05,s_geh[1].gehacti
 
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
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('gehuser', 'gehgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL i401_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i401_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680102CHAR(200)
 
    LET g_sql = "SELECT geh01,geh02,geh04,geh03,geh05,gehacti",   #No.FUN-590001
                " FROM geh_file",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                " ORDER BY geh04,geh01"
    PREPARE i401_pb FROM g_sql
    DECLARE geh_curs CURSOR FOR i401_pb
 
    CALL g_geh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
 
    FOREACH geh_curs INTO g_geh[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_geh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i401_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_geh TO s_geh.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780056 --str
{
FUNCTION i401_out()
    DEFINE
        l_geh   RECORD LIKE geh_file.*,
        l_i     LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_name  LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05  LIKE za_file.za05             #No.FUN-680102 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN 
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM geh_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i401_p1 FROM g_sql                    # RUNTIME 編譯
    DECLARE i401_co                               # SCROLL CURSOR
         CURSOR FOR i401_p1
 
    CALL cl_outnam('aooi401') RETURNING l_name
    START REPORT i401_rep TO l_name
 
    FOREACH i401_co INTO l_geh.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i401_rep(l_geh.*)
    END FOREACH
 
    FINISH REPORT i401_rep
 
    CLOSE i401_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i401_rep(sr)
    DEFINE
        l_trailer_sw LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
        sr           RECORD LIKE geh_file.*
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
    ORDER BY sr.geh04,sr.geh01
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED       # No.TQC-750041
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.geh01,
                  COLUMN g_c[32],sr.geh02,
                  COLUMN g_c[33],sr.geh03,
                  COLUMN g_c[34],sr.geh05,
                  COLUMN g_c[35],sr.geh04,
                  COLUMN g_c[36],sr.gehacti               # No.TQC-750041 
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780056 --end
 
#No.FUN-570110 --start                                                          
FUNCTION i401_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("geh01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i401_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("geh01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end            
