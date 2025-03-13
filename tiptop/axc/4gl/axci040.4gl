# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axci040.4gl
# Descriptions...: 成本中心成本項目分攤設定
# Date & Author..: 01/11/20 BY DS/P
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-570306 05/07/22 By pengu  1.在修改狀態時在單身資料中移動,遇到部門資料不存在時,會無法結束程式
                                          #       ,一直出現promt的畫面
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660160 06/06/23 By Sarah 根據參數(ccz06)進行輸入值為'部門代號'或'作業編號'或'工作中心'的檢查
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-730057 07/03/27 By bnlent 會計科目加帳套 
# Modify.........: No.TQC-740120 07/04/17 By Sarah PROMPT訊息沒照規範寫
# Modify.........: No.FUN-7C0101 08/03/05 By douzh 成本改善調整
# Modify.........: No.MOD-870035 08/07/16 By Pengu 無任何資料的情況下查詢點選成本中心開窗查詢程式就會自動關閉
# Modify.........: No.FUN-910031 09/01/14 By kim 十號公報 for 重複性生產
# Modify.........: No.CHI-940027 09/04/22 By ve007 制費分為5大類
# Modify.........: No.CHI-970021 09/08/20 By jan 加上'類型' '部門編號'兩個key值欄位
# Modify.........: No.TQC-970157 09/08/28 By destiny caa02,caa05 after field后面增加管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:FUN-B40004 11/04/13 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No:CHI-C40026 12/08/13 By ck2yuan 畫面上新增一個欄位  '科目名稱'
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_caa           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
                 caa01  LIKE caa_file.caa01,
                 caa02  LIKE caa_file.caa02,
                 cab02  LIKE cab_file.cab02,  #成本項目說明
                 caa04  LIKE caa_file.caa04,
                 caa05  LIKE caa_file.caa05,
                 aag02  LIKE aag_file.aag02,  #CHI-C40026 add
                 caa06  LIKE caa_file.caa06,
                 caa07  LIKE caa_file.caa07,  #FUN-910031
                 caa08  LIKE caa_file.caa08,  #FUN-910031
                 caa09  LIKE caa_file.caa09,  #CHI-970021
                 caa10  LIKE caa_file.caa10,  #CHI-970021
                 gem02  LIKE gem_file.gem02   #CHI-970021
                    END RECORD,
    g_caa_t         RECORD                 #程式變數 (舊值)
                 caa01  LIKE caa_file.caa01,
                 caa02  LIKE caa_file.caa02,
                 cab02  LIKE cab_file.cab02,  #成本項目說明
                 caa04  LIKE caa_file.caa04,
                 caa05  LIKE caa_file.caa05,
                 aag02  LIKE aag_file.aag02,  #CHI-C40026 add
                 caa06  LIKE caa_file.caa06,
                 caa07  LIKE caa_file.caa07,  #FUN-910031
                 caa08  LIKE caa_file.caa08,   #FUN-910031
                 caa09  LIKE caa_file.caa09,  #CHI-970021
                 caa10  LIKE caa_file.caa10,  #CHI-970021
                 gem02  LIKE gem_file.gem02   #CHI-970021
                    END RECORD,
    g_wc2,g_sql     string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done      LIKE type_file.num5            #No.FUN-570110     #No.FUN-680122 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5              #No.FUN-680122 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
       RETURNING g_time    #No.FUN-6A0146
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW i040_w AT p_row,p_col WITH FORM "axc/42f/axci040"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i040_b_fill(g_wc2)
    CALL i040_menu()
    CLOSE WINDOW i040_w                      #結束畫面
      CALL  cl_used(g_prog,g_time,2)         #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION i040_menu()
 
   WHILE TRUE
      CALL i040_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i040_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i040_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         
         #NO.CHI-940027 --begin--
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL i040_out()
            END IF  
         #NO.CHI-940027 --end--
         
         #FUN-4B0015
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_caa),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
##No:A088
##
FUNCTION i040_q()
   CALL i040_b_askkey()
END FUNCTION
 
FUNCTION i040_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                                   #No.FUN-680122 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                                    #No.FUN-680122 VARCHAR(1)
DEFINE l_flag          LIKE type_file.chr1                 #No.CHI-940027   
#No.TQC-970157--begin                                                                                                               
DEFINE                                                                                                                              
    l_count         LIKE type_file.num5,                                                                                            
    l_count1        LIKE type_file.num5,                                                                                            
    l_aagacti       LIKE aag_file.aagacti                                                                                           
#No.TQC-970157--end   
DEFINE  l_aag05     LIKE aag_file.aag05                  #No.FUN-B40004
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT caa01,caa02,'',caa04,caa05,caa06,caa07,caa08,caa09,caa10,'' ",  #FUN-910031 #CHI-970021 add caa09.caa10 #CHI-C40026 mark
    LET g_forupd_sql = "SELECT caa01,caa02,'',caa04,caa05,'',caa06,caa07,caa08,caa09,caa10,'' ", #CHI-C40026 add
                       " FROM caa_file WHERE caa01=? AND caa02=? AND caa04=? AND caa05=? AND caa09=? AND caa10=? FOR UPDATE" #CHI-970021 add caa09,10
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i040_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_caa WITHOUT DEFAULTS FROM s_caa.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
          UNBUFFERED, INSERT ROW = l_allow_insert,
          DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
               LET g_caa_t.* = g_caa[l_ac].*  #BACKUP
#No.FUN-570110--begin
               LET g_before_input_done = FALSE
               CALL i040_set_entry_b(p_cmd)
               CALL i040_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110--end
               BEGIN WORK
 
               OPEN i040_bcl USING g_caa_t.caa01,g_caa_t.caa02,g_caa_t.caa04,g_caa_t.caa05,g_caa_t.caa09,g_caa_t.caa10  #CHI-970021 add caa09,caa10
               IF STATUS THEN
                  CALL cl_err("OPEN i040_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i040_bcl INTO g_caa[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_caa_t.caa01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  #CHI-970021--BEGIN--
                  IF g_caa[l_ac].caa09 ='1'THEN
                     CALL cl_set_comp_entry("caa10",TRUE)
                  ELSE
                     CALL cl_set_comp_entry("caa10",FALSE)
                  END IF
                  SELECT gem02 INTO g_caa[l_ac].gem02 FROM gem_file
                  WHERE gem01 = g_caa[l_ac].caa10 
                  #CHI-970021--END--
                  SELECT aag02 INTO g_caa[l_ac].aag02 FROM aag_file     #CHI-C40026 add
                   WHERE aag00=g_aza.aza81 AND aag01=g_caa[l_ac].caa05  #CHI-C40026 add
               END IF
               IF l_ac <= l_n then                   #DISPLAY NEWEST
                  select cab02 into g_caa[l_ac].cab02 from cab_file
                   where cab01=g_caa[l_ac].caa02
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin
            LET g_before_input_done = FALSE
            CALL i040_set_entry_b(p_cmd)
            CALL i040_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110--end
            INITIALIZE g_caa[l_ac].* TO NULL      #900423
            LET g_caa[l_ac].caa07='2'      #FUN-910031
            LET g_caa_t.* = g_caa[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD caa01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
#           CALL g_caa.deleteElement(l_ac)   # 重要
#           IF g_rec_b != 0 THEN
#             LET g_action_choice = "detail"
#           END IF
#           EXIT INPUT
         END IF
         IF g_caa[l_ac].caa05 !=g_caa_t.caa05 OR
            g_caa[l_ac].caa04 !=g_caa_t.caa04 OR
            g_caa[l_ac].caa02 !=g_caa_t.caa02 OR
            g_caa[l_ac].caa09 !=g_caa_t.caa09 OR   #CHI-970021
            g_caa[l_ac].caa10 !=g_caa_t.caa10 OR   #CHI-970021
            g_caa[l_ac].caa01 !=g_caa_t.caa01 THEN
            SELECT COUNT(*) INTO g_cnt  FROM caa_file
             WHERE caa01=g_caa[l_ac].caa01
               AND caa02=g_caa[l_ac].caa02
               AND caa04=g_caa[l_ac].caa04
               AND caa05=g_caa[l_ac].caa05
               AND caa09=g_caa[l_ac].caa09   #CHI-970021
               AND caa10=g_caa[l_ac].caa10   #CHI-970021
            IF g_cnt > 0  THEN
              LET g_msg=g_caa[l_ac].caa01 CLIPPED,'+',g_caa[l_ac].caa02 CLIPPED,
                  '+',g_caa[l_ac].caa04 CLIPPED,'+',g_caa[l_ac].caa05 CLIPPED,
                  '+',g_caa[l_ac].caa09 CLIPPED,'+',g_caa[l_ac].caa10 CLIPPED  #CHI-970021
              LET STATUS=-239
              CALL cl_err(g_msg,STATUS,1) NEXT FIELD caa05
            END IF
         END IF
 
         IF cl_null(g_caa[l_ac].caa10) THEN LET g_caa[l_ac].caa10 = ' ' END IF   #CHI-970021
         INSERT INTO caa_file(caa01,caa02,caa04,caa05,caa06,caa07,caa08,caa09,caa10)  #FUN-910031 #CHI-970021 add caa09,caa10
         VALUES(g_caa[l_ac].caa01,g_caa[l_ac].caa02,
                g_caa[l_ac].caa04,g_caa[l_ac].caa05,
                g_caa[l_ac].caa06,g_caa[l_ac].caa07,g_caa[l_ac].caa08, #FUN-910031
                g_caa[l_ac].caa09,g_caa[l_ac].caa10)    #CHI-970021
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_caa[l_ac].caa01,SQLCA.sqlcode,0)   #No.FUN-660127
             CALL cl_err3("ins","caa_file",g_caa[l_ac].caa01,g_caa[l_ac].caa02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
        AFTER FIELD caa01                        #check 編號是否重複
            IF NOT cl_null(g_caa[l_ac].caa01) THEN
             #start FUN-660160 modify
             #SELECT COUNT(*) INTO g_cnt FROM gem_file
             #WHERE gem01=g_caa[l_ac].caa01
             #  AND gemacti='Y'   #NO:6950
              CASE g_ccz.ccz06
                 WHEN '3'
                    SELECT COUNT(*) INTO g_cnt
                      FROM ecd_file
                     WHERE ecd01 = g_caa[l_ac].caa01
                       AND ecdacti='Y'
                 WHEN '4'
                    SELECT COUNT(*) INTO g_cnt
                      FROM eca_file
                     WHERE eca01 = g_caa[l_ac].caa01
                       AND ecaacti='Y'
                 OTHERWISE
                    SELECT COUNT(*) INTO g_cnt
                      FROM gem_file
                     WHERE gem01 = g_caa[l_ac].caa01
                       AND gemacti='Y'
              END CASE
             #end FUN-660160 modify
              LET INT_FLAG = 0  ######add for prompt bug
              IF g_cnt =0 AND (p_cmd='a' OR g_chkey='Y') THEN    #No.MOD-570306 add p_cmd g_chkey 判斷
                #str TQC-740120 modify
                #PROMPT "不存在部門檔內!" FOR g_chr   
                 CALL cl_err('','anm-071',1)
                #end TQC-740120 modify
                 NEXT FIELD caa01
             END IF
            END IF
 
        AFTER FIELD caa02
            IF g_caa[l_ac].caa02 IS NOT NULL THEN
               #No.TQC-970157--begin                                                                                                
               SELECT COUNT(*) INTO l_count                                                                                         
                 FROM cab_file                                                                                                      
                WHERE cab01=g_caa[l_ac].caa02                                                                                       
               IF l_count=0 THEN                                                                                                    
                  CALL cl_err('','mfg1313',1)                                                                                       
                  LET g_caa[l_ac].caa02=g_caa_t.caa02                                                                               
                  NEXT FIELD caa02                                                                                                  
               END IF                                                                                                               
               #No.TQC-970157--end     
               SELECT cab02 INTO g_caa[l_ac].cab02 FROM cab_file
                WHERE cab01=g_caa[l_ac].caa02
            END IF
        
        #NO.CHI-940027 --begin--
        AFTER FIELD caa04
         IF NOT cl_null(g_caa[l_ac].caa04) THEN 
            IF g_caa[l_ac].caa04 NOT MATCHES '[123456]' THEN
               NEXT FIELD caa04
            END IF
         END IF             
        #NO.CHI-940027 --end--
        
        AFTER FIELD caa05
          IF g_caa[l_ac].caa05 IS NOT NULL THEN
             #No.TQC-970157--begin                                                                                                  
             SELECT COUNT(*) INTO l_count1                                                                                          
               FROM aag_file                                                                                                        
              WHERE aag01=g_caa[l_ac].caa05                                                                                         
                AND aag00=g_aza.aza81                                                                                               
             IF l_count1=0 THEN                                                                                                     
#FUN-B10052 --begin--              
#               CALL cl_err('','mfg9086',1)                                                                                                
#               LET g_caa[l_ac].caa05=g_caa_t.caa05      
                 CALL cl_err('','mfg9086',0)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_caa[l_ac].caa02
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.arg1 = g_aza.aza81                
                  LET g_qryparam.where = " aag01 LIKE '",g_caa[l_ac].caa05 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_caa[l_ac].caa05
                  DISPLAY g_caa[l_ac].caa05 TO caa05
#FUN-B10052 --end--
                NEXT FIELD caa05                                                                                                    
             END IF                                                                                                                 
             SELECT aagacti INTO l_aagacti                                                                                          
               FROM aag_file                                                                                                        
              WHERE aag01=g_caa[l_ac].caa05                                                                                         
                AND aag00=g_aza.aza81                                                                                               
             IF l_aagacti !='Y' THEN                                                                                                
                CALL cl_err('','axc-303',1)                                                                                         
                LET g_caa[l_ac].caa05=g_caa_t.caa05                                                                                 
                NEXT FIELD caa05                                                                                                    
             END IF                                                                                                                 
             #No.TQC-970157--end  
             IF g_caa[l_ac].caa05 !=g_caa_t.caa05 OR
                g_caa[l_ac].caa04 !=g_caa_t.caa04 OR
                g_caa[l_ac].caa02 !=g_caa_t.caa02 OR
                g_caa[l_ac].caa01 !=g_caa_t.caa01 OR
                g_caa[l_ac].caa09 !=g_caa_t.caa09 OR  #CHI-970021
                g_caa[l_ac].caa10 !=g_caa_t.caa10 OR  #CHI-970021
                g_caa_t.caa05 IS NULL OR g_caa_t.caa04 IS NULL
               OR g_caa_t.caa09 IS NULL OR g_caa_t.caa10 IS NULL  #CHI-970021
               OR g_caa_t.caa02 IS NULL OR g_caa_t.caa01 IS NULL THEN
               SELECT COUNT(*) INTO g_cnt  FROM caa_file
               WHERE caa01=g_caa[l_ac].caa01
                 AND caa02=g_caa[l_ac].caa02
                 AND caa04=g_caa[l_ac].caa04
                 AND caa05=g_caa[l_ac].caa05
                 AND caa09=g_caa[l_ac].caa09   #CHI-970021
                 AND caa10=g_caa[l_ac].caa10   #CHI-970021
               IF g_cnt > 0  THEN
                 LET g_msg=g_caa[l_ac].caa01 CLIPPED,'+',g_caa[l_ac].caa02 CLIPPED,
                       '+',g_caa[l_ac].caa04 CLIPPED,'+',g_caa[l_ac].caa05 CLIPPED,
                       '+',g_caa[l_ac].caa09 CLIPPED,'+',g_caa[l_ac].caa10 CLIPPED   #CHI-970021
                 LET STATUS=-239
                 CALL cl_err(g_msg,STATUS,1) NEXT FIELD caa05
               END IF
             END IF
          END IF
        
        #No.CHI-940027 --begin--
        BEFORE FIELD caa06
         #相同"成本中心(caa01)+成本項目(caa02)"帶入別筆caa06
         SELECT DISTINCT caa06 INTO g_caa[l_ac].caa06 FROM caa_file
           WHERE caa01=g_caa[l_ac].caa01 AND caa02=g_caa[l_ac].caa02
         DISPLAY g_caa[l_ac].caa06 TO s_caa[l_ac].caa06
         
        AFTER FIELD caa06
           IF NOT cl_null(g_caa[l_ac].caa06) THEN
               #限制相同"成本中心(cda01)+成本項目(cdb02)"其分攤方式(cda06)需一致
               LET l_flag = 'Y'
               CALL i040_caa06(p_cmd) RETURNING l_flag,g_caa[l_ac].caa06
               IF l_flag ='N' THEN
                  #同一成本中心+成本項目其分攤方式只能有一種！
                  CALL cl_err('','axc-295',0)
                  DISPLAY g_caa[l_ac].caa06 TO s_caa[l_ac].caa06
                  NEXT FIELD caa06
               END IF
           END IF 
        #No.CHI-940027 --end--
        
        #FUN-910031...................begin
        AFTER FIELD caa07
           IF NOT cl_null(g_caa[l_ac].caa07) THEN
              IF g_caa[l_ac].caa07='1' THEN
                 CALL cl_set_comp_entry("caa08",TRUE)
              ELSE
                 CALL cl_set_comp_entry("caa08",FALSE)
                 LET g_caa[l_ac].caa08 = NULL
                 DISPLAY BY NAME g_caa[l_ac].caa08
              END IF
           END IF
 
        #FUN-910031...................end
        
        #CHI-970021--BEGIN-- 
        AFTER FIELD caa09
        IF g_caa[l_ac].caa09 IS NOT NULL THEN
           IF g_caa[l_ac].caa09 ='1'THEN
              CALL cl_set_comp_entry("caa10",TRUE)
           ELSE 
              CALL cl_set_comp_entry("caa10",FALSE)
              LET g_caa[l_ac].caa10 = ' '
              DISPLAY BY NAME g_caa[l_ac].caa10
           END IF
        ELSE
           NEXT FIELD caa09
        END IF
 
       AFTER FIELD caa10
        IF g_caa[l_ac].caa10 IS NOT NULL THEN
           IF g_caa_t.caa10 IS NULL OR
              (g_caa[l_ac].caa10 != g_caa_t.caa10) THEN
              CALL i040_caa10(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_caa[l_ac].caa10,g_errno,0)
                 LET g_caa[l_ac].caa10 = g_caa_t.caa10
                 DISPLAY BY NAME g_caa[l_ac].caa10
                 NEXT FIELD caa10
              END IF
              SELECT COUNT(*) INTO l_n FROM gem_file
               WHERE gem01 = g_caa[l_ac].caa10
                 AND gemacti = 'Y'
              IF l_n = 0 THEN
                 CALL cl_err('','anm-071',0)
                 NEXT FIELD caa10
              END IF
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt  FROM caa_file
               WHERE caa01=g_caa[l_ac].caa01
                 AND caa02=g_caa[l_ac].caa02
                 AND caa05=g_caa[l_ac].caa05
                 AND caa04=g_caa[l_ac].caa04
                 AND caa09=g_caa[l_ac].caa09
                 AND caa10=g_caa[l_ac].caa10
              IF g_cnt > 0  THEN
                 LET g_msg=g_caa[l_ac].caa01 CLIPPED,'+',g_caa[l_ac].caa02 CLIPPED,'+',g_caa[l_ac].caa04,
                      '+',g_caa[l_ac].caa05 CLIPPED,'+',g_caa[l_ac].caa09 CLIPPED,'+',g_caa[l_ac].caa10 CLIPPED
                 LET STATUS=-239
                 CALL cl_err(g_msg,STATUS,1) 
                 NEXT FIELD caa10
              END IF
              #No.FUN-B40004  --Begin
              LET l_aag05=''
              SELECT aag05 INTO l_aag05 FROM aag_file
               WHERE aag01 = g_caa[l_ac].caa05
                 AND aag00 = g_aza.aza81
              IF l_aag05 = 'Y' THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    LET g_errno = ' '
                    CALL s_chkdept(g_aaz.aaz72,g_caa[l_ac].caa05,g_caa[l_ac].caa10,g_aza.aza81)
                         RETURNING g_errno
                 END IF
              END IF
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_caa[l_ac].caa10,g_errno,0)
                 DISPLAY BY NAME g_caa[l_ac].caa10
                 NEXT FIELD caa10 
              END IF
              #No.FUN-B40004  --End
              
           END IF
        ELSE
           LET g_caa[l_ac].caa10 = ' '
        END IF 
        IF cl_null(g_caa[l_ac].caa01) THEN
           LET g_caa[l_ac].caa01 = ' ' 
        END IF
      #CHI-970021--END-- 
        
        BEFORE DELETE                            #是否取消單身
              IF g_caa_t.caa01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM caa_file WHERE caa01=g_caa_t.caa01
                                       AND caa02=g_caa_t.caa02
                                       AND caa04=g_caa_t.caa04
                                       AND caa05=g_caa_t.caa05
                                       AND caa09=g_caa_t.caa09   #CHI-970021
                                       AND caa10=g_caa_t.caa10   #CHI-970021
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_caa_t.caa01,SQLCA.sqlcode,0)   #No.FUN-660127
                   CALL cl_err3("del","caa_file",g_caa_t.caa01,g_caa_t.caa02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i040_bcl
                COMMIT WORK
              END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_caa[l_ac].* = g_caa_t.*
              CLOSE i040_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_caa[l_ac].caa01,-263,1)
              LET g_caa[l_ac].* = g_caa_t.*
           ELSE
              UPDATE caa_file SET
                 caa01=g_caa[l_ac].caa01,
                 caa02=g_caa[l_ac].caa02,
                 caa04=g_caa[l_ac].caa04,
                 caa05=g_caa[l_ac].caa05,
                 caa06=g_caa[l_ac].caa06,
                 caa09=g_caa[l_ac].caa09, #CHI-970021
                 caa10=g_caa[l_ac].caa10, #CHI-970021
                 caa07=g_caa[l_ac].caa07, #FUN-910031
                 caa08=g_caa[l_ac].caa08  #FUN-910031
              WHERE caa01=g_caa_t.caa01 #g_caa[l_ac].caa01
                AND caa02=g_caa_t.caa02 #g_caa[l_ac].caa02
                AND caa04=g_caa_t.caa04 #g_caa[l_ac].caa04
                AND caa05=g_caa_t.caa05 #g_caa[l_ac].caa05
                AND caa09=g_caa_t.caa09 #CHI-970021
                AND caa10=g_caa_t.caa10 #CHI-970021
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_caa[l_ac].caa01,SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("upd","caa_file",g_caa[l_ac].caa01,g_caa[l_ac].caa02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                  LET g_caa[l_ac].* = g_caa_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i040_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_caa[l_ac].* = g_caa_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_caa.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE i040_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i040_bcl
            COMMIT WORK
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(caa01)
                 #start FUN-660160 modify
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_gem"
                 #LET g_qryparam.default1 = g_caa[l_ac].caa01
                 #CALL cl_create_qry() RETURNING g_caa[l_ac].caa01
                  CASE g_ccz.ccz06
                     WHEN '3'
                        CALL q_ecd(FALSE,TRUE,g_caa[l_ac].caa01)
                             RETURNING g_caa[l_ac].caa01
                     WHEN '4'
                        CALL q_eca(FALSE,TRUE,g_caa[l_ac].caa01)
                             RETURNING g_caa[l_ac].caa01
                     OTHERWISE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     ="q_gem"
                        LET g_qryparam.default1 = g_caa[l_ac].caa01
                        CALL cl_create_qry() RETURNING g_caa[l_ac].caa01
                  END CASE
                 #end FUN-660160 modify
                  DISPLAY "CAA01=",g_caa[l_ac].caa01
                  DISPLAY g_caa[l_ac].caa01 TO caa01
                  NEXT FIELD caa01
                  #CALL FGL_DIALOG_SETBUFFER( g_caa[l_ac].caa01 )
               WHEN INFIELD(caa02)
                 #CALL q_cab(10,3,g_caa[l_ac].caa02) RETURNING g_caa[l_ac].caa02
                 #CALL FGL_DIALOG_SETBUFFER( g_caa[l_ac].caa02 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_cab"
                  LET g_qryparam.default1 = g_caa[l_ac].caa02
                  CALL cl_create_qry() RETURNING g_caa[l_ac].caa02
                  DISPLAY g_caa[l_ac].caa02 TO caa02
                  #CALL FGL_DIALOG_SETBUFFER( g_caa[l_ac].caa02 )
                  IF NOT cl_null(g_caa[l_ac].caa02) THEN
                     SELECT cab02 INTO g_caa[l_ac].cab02 FROM cab_file
                      WHERE cab01=g_caa[l_ac].caa02
                  END IF
                  NEXT FIELD caa02
               WHEN INFIELD(caa05)
                 #CALL q_aag(10,3,g_caa[l_ac].caa02,'','','') RETURNING g_caa[l_ac].caa05
#                  CALL FGL_DIALOG_SETBUFFER( g_caa[l_ac].caa05 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.default1 = g_caa[l_ac].caa02
                  LET g_qryparam.arg1 = g_aza.aza81                #No.FUN-730057
                  CALL cl_create_qry() RETURNING g_caa[l_ac].caa05
                  DISPLAY g_caa[l_ac].caa05 TO caa05
                  NEXT FIELD caa05
                  #CALL FGL_DIALOG_SETBUFFER( g_caa[l_ac].caa05 )
               #CHI-970021--BEGIN--
               WHEN INFIELD(caa10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gem"
                  LET g_qryparam.default1 = g_caa[l_ac].caa10
                  CALL cl_create_qry() RETURNING g_caa[l_ac].caa10
                  DISPLAY g_caa[l_ac].caa10 TO caa10
                  NEXT FIELD caa10
               #CHI-970021--END--
               OTHERWISE
                  EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i040_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(caa01) AND l_ac > 1 THEN
                LET g_caa[l_ac].* = g_caa[l_ac-1].*
                NEXT FIELD caa01
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
 
    CLOSE i040_bcl
    COMMIT WORK
END FUNCTION
 
#CHI-970021--BEGIN--
FUNCTION i040_caa10(p_cmd)
DEFINE l_gemacti     LIKE gem_file.gemacti
DEFINE p_cmd         LIKE type_file.chr1
 
    LET g_errno = " " 
    SELECT gem02,gemacti
      INTO g_caa[l_ac].gem02,l_gemacti
      FROM gem_file WHERE gem01=g_caa[l_ac].caa10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-471'                                                                           
                           LET g_caa[l_ac].gem02 = NULL                                                                             
        WHEN l_gemacti='N' LET g_errno = '9028'                                                                                     
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'                                                              
    END CASE                                  
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN                                                                                          
      DISPLAY BY NAME g_caa[l_ac].gem02                                                                                             
   END IF
END FUNCTION
#CHI-970021--END--
FUNCTION i040_b_askkey()
    CLEAR FORM
    CALL g_caa.clear()
    CONSTRUCT g_wc2 ON caa01,caa02,caa04,caa05,caa06,caa07,caa08,caa09,caa10  #FUN-910031 #CHI-970021
            FROM s_caa[1].caa01,s_caa[1].caa02,s_caa[1].caa04,
                 s_caa[1].caa05,s_caa[1].caa06,s_caa[1].caa07,s_caa[1].caa08, #TQC-8C0052 #FUN-910031
                 s_caa[1].caa09,s_caa[1].caa10     #CHI-970021 add
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    ON ACTION controlp   
       CASE
              WHEN INFIELD(caa01)
                #start FUN-660160 modify
                #CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_gem"
                #LET g_qryparam.state    = "c"
                #LET g_qryparam.default1 = g_caa[l_ac].caa01
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CASE g_ccz.ccz06
                    WHEN '3'
                       CALL q_ecd(TRUE,TRUE,g_caa[1].caa01)    #No.MOD-870035 modify
                            RETURNING g_qryparam.multiret
                    WHEN '4'
                       CALL q_eca(TRUE,TRUE,g_caa[1].caa01)    #No.MOD-870035 modify
                            RETURNING g_qryparam.multiret
                    OTHERWISE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form     ="q_gem"
                       LET g_qryparam.state    = "c"
                      #LET g_qryparam.default1 = g_caa[l_ac].caa01    #No.MOD-870035 mark
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                 END CASE
                #end FUN-660160 modify
                 DISPLAY g_qryparam.multiret TO s_caa[1].caa01
              WHEN INFIELD(caa02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_cab"
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.default1 = g_caa[1].caa02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_caa[1].caa02
                 IF NOT cl_null(g_caa[1].caa02) THEN
                    SELECT cab02 INTO g_caa[1].cab02 FROM cab_file
                     WHERE cab01=g_caa[1].caa02
                 END IF
              WHEN INFIELD(caa05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_aag"
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.default1 = g_caa[1].caa02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_caa[1].caa05
              #CHI-970021--BEGIN--
              WHEN INFIELD(caa10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gem"
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.default1 = g_caa[1].caa10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_caa[1].caa10
               #FUN-920010--END--
              OTHERWISE
                 EXIT CASE
           END CASE
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i040_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i040_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200) 
DEFINE l_aag02      LIKE aag_file.aag02          #CHI-C40026 add
 
    LET g_sql =
       #"SELECT caa01,caa02,cab02,caa04,caa05,caa06,caa07,caa08,caa09,caa10,'' ",  #FUN-910031 #CHI-970021 add caa09,caa10,''  #CHI-C40026 mark
        "SELECT caa01,caa02,cab02,caa04,caa05,'',caa06,caa07,caa08,caa09,caa10,'' ",  #CHI-C40026 add
        " FROM caa_file,cab_file ",
        " WHERE caa02=cab01 AND ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i040_pb FROM g_sql
    DECLARE caa_curs CURSOR FOR i040_pb
 
    CALL g_caa.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH caa_curs INTO g_caa[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #CHI-970021--BEGIN--
      SELECT gem02 INTO g_caa[g_cnt].gem02 FROM gem_file
       WHERE gem01 = g_caa[g_cnt].caa10
      IF SQLCA.sqlcode THEN
         LET g_caa[g_cnt].gem02 = NULL
      END IF
      #CHI-970021--end--
     #CHI-C40026 str add-----
      SELECT aag02 INTO g_caa[g_cnt].aag02 FROM aag_file
       WHERE aag00=g_aza.aza81 AND aag01=g_caa[g_cnt].caa05
      IF SQLCA.sqlcode THEN
         LET g_caa[g_cnt].aag02 = NULL
      END IF
     #CHI-C40026 end add-----
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
 
    MESSAGE ""
    CALL g_caa.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
{
FUNCTION i040_caa04(p_caa04)
  DEFINE p_caa04  LIKE caa_file.caa04
  DEFINE l_desc   LIKE type_file.chr8           #No.FUN-680122 VARCHAR(8) 
 
  LET l_desc=''
  CASE p_caa04
    WHEN '1'  LET l_desc='人工成本'
    WHEN '2'  LET l_desc='製造費用'
  END CASE
  RETURN l_desc
END FUNCTION
}
{
FUNCTION i040_caa06(p_caa06)
  DEFINE p_caa06  LIKE caa_file.caa06
  DEFINE l_desc   LIKE type_file.chr8           #No.FUN-680122CHAR(8) 
 
  LET l_desc=''
  CASE p_caa06
    WHEN '1'  LET l_desc='實際工時'
    WHEN '2'  LET l_desc='標準工時'
    WHEN '3'  LET l_desc='產出數量'
  END CASE
  RETURN l_desc
END FUNCTION
}
FUNCTION i040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_caa TO s_caa.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      
      
      #NO.CHI-940027 --begin--
      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DISPLAY 
      #NO.CHI-940027 --end--
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0015
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-570110--begin
FUNCTION i040_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("caa01,caa02,caa04,caa05,caa09",TRUE) #CHI-970021
   END IF
   #FUN-910031...................begin
   IF g_caa[l_ac].caa07='1' THEN
      CALL cl_set_comp_entry("caa08",TRUE)
   END IF
   #FUN-910031...................end
END FUNCTION
 
FUNCTION i040_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("caa01,caa02,caa04,caa05,caa09",FALSE) #CHI-970021
   END IF
   #FUN-910031...................begin
   IF g_caa[l_ac].caa07<>'1' OR cl_null(g_caa[l_ac].caa07) THEN
      CALL cl_set_comp_entry("caa08",FALSE)
   END IF
   #FUN-910031...................end
END FUNCTION
#No.FUN-570110--end
#NO.CHI-940027 --begin--
FUNCTION i040_caa06(p_cmd)
    DEFINE p_cmd      LIKE type_file.chr1
    DEFINE l_caa06    LIKE caa_file.caa06
    DEFINE l_caa06_t  LIKE caa_file.caa06
    
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM caa_file
     WHERE caa01=g_caa[l_ac].caa01 AND caa02=g_caa[l_ac].caa02
    IF (p_cmd='u' AND g_cnt > 1) OR (p_cmd='a' AND g_cnt > 0) THEN
       #限制相同"成本中心(caa01)+成本項目(cab02)"其分攤方式(caa06)需一致
       #所以檢查當輸入的caa06的值不等於已存在的,將值改成跟已存在資料庫裡的
       DECLARE caa06_curs CURSOR FOR 
          SELECT DISTINCT caa06 FROM caa_file
           WHERE caa01=g_caa[l_ac].caa01 AND caa02=g_caa[l_ac].caa02
           ORDER BY caa06
 
       FOREACH caa06_curs INTO l_caa06  
          IF l_caa06!=' ' AND g_caa[l_ac].caa06!=l_caa06 THEN
             RETURN 'N',l_caa06
          END IF
       END FOREACH
    END IF
    RETURN 'Y',g_caa[l_ac].caa06
 
END FUNCTION
 
FUNCTION i040_out()
    DEFINE  l_cmd  LIKE type_file.chr1000
    
    IF  cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
    LET l_cmd = 'p_query "axci040" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                          
    RETURN  
END FUNCTION 
 
#NO.CHI-940027 --end--
 
#Patch....NO.TQC-610037 <001> #
#No.FUN-7C0101 #
