# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: gglp301.4gl
# Descriptions...: 合併資料產生作業(整批資料處理作業)
# Input parameter: 
# Return code....: 
# Modify.........: No:9705 04/07/09 By Nicola Select條件修改
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-580063 05/09/07 By Sarah 執行會當掉
# Modify.........: No.FUN-5A0020 05/10/06 By Sarah 幣別請塞入上層公司的記帳幣別
# Modify ........: No.FUN-570145 06/02/24 By YITING 批次背景執行
# Modify.........: No.FUN-630063 06/03/22 By ching bookno應是asa03
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.MOD-6A0039 06/10/14 By Smapmin 年度與月份不應受限於aaa07
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/16 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-740252 07/04/27 By Sarah asr_file與asg_file的連接key值應該是asr02=asg01
# Modify.........: No.FUN-750058 07/05/23 By kim 增加版本欄位
# Modify.........: No.FUN-760044 07/06/15 By Sarah 隱藏畫面的版本欄位,計算時寫死抓版本00的資料
# Modify.........: No.FUN-770069 07/07/25 By Sarah 寫入atc_file時,除了寫入版本為00的資料外,要再寫入版本為截止期別(tm.em)的資料
# Modify.........: No.FUN-8A0086 08/10/20 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910023 09/01/08 By Sarah 增加合併後異動碼餘額檔atcc_file
# Modify.........: NO.FUN-930117 09/03/17 BY hongmei pk值異動，相關程式修改
# Modify.........: No.FUN-950048 09/06/08 By hongmei 畫面上的起始期別設為noentry,并且預設為0     
# Modify.........: NO.FUN-920076 09/02/10 BY yiting 1.gglp301在抓取asr_file,ass_file時 ，應以上層公司合併帳別為條件
# Modify.........: NO.FUN-980067 09/10/30 BY yiting gglp301處理時，日期區間改為都抓當月異動
# Modify.........: NO.MOD-9C0421 09/12/29 BY jan atcc_file沒有處理atcclegal
# Modify.........: No:MOD-A20028 10/02/22 By Sarah 調整g_aaz641抓取的時間點
# Modify.........: NO.MOD-A30100 10/03/17 By Dido 調整 UPDATE atcc_file key 值 
# Modify.........: No.FUN-A30064 10/03/30 By vealxu 不做獨立合併會科時，DB取aaz641
# Modify.........: No.FUN-A50102 10/07/27 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.......... NO.MOD-A40192 10/04/30 by yiting 1.在AFTER INPUT重取aaz641 2.insert into atcc_file要只取有關係人的
# Modidy.........: No.FUN-A30122 10/08/23 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641_asg,s_aaz641_asg
# Modify.........: No:FUN-9B0017 10/09/01 By chenmoyan 將異動碼科目餘額檔asl_file做滾算至合併前科目異動碼(固定)沖帳餘額檔asll_file,提供後續部門合併財報使用
# Modify.........: NO.FUN-A10015 10/09/13 By chenmoyan asll_file表結構異動
# Modify.........: NO.MOD-A40192 10/04/30 by yiting 1.在AFTER INPUT重取aaz641 2.insert into atcc_file要只取有關係人的
# Modify.........: NO.FUN-A90026 10/09/14 BY yiting 2.輸入增加選項
# Modify.........: NO.TQC-AA0098 10/10/16 BY yiting 群組及公司代號都有值時，才call s_aaaz641_dbs
# Modify.........: NO.FUN-AA0093 10/10/28 BY yiting 捲算時應排除本期損益IS科目
# Modify.........: NO.MOD-AC0232 10/12/20 BY yiting insert into asll_file抓取欄位及GROUP BY 應該都為上層公司
# Modify.........: NO:CHI-B10030 11/01/24 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO:TQC-B20178 11/08/09 BY belle 寫入asll_file時不用寫入匯率,待aglp001捲算時再計算 
# Modify.........: NO:MOD-B80141 11/08/16 BY polly 寫入asll_file時不用寫入asl16，待aglp001捲算時再計算
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr
# Modify.........: No.TQC-C90057 12/09/20 By Carrier aaz113改成asz05
# Modify.........: No:MOD-CA0069 12/10/11 By wujie  DELETE asll_file时有多余的条件
# Modify.........: No:TQC-CA0063 12/10/31 By fengmy 合併報表累加數據，加入內部抵消以及會計師調整中的抵消數據 
# Modify.........: No:TQC-CB0085 12/11/27 By fengmy 調整g_bookno默認值

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006 
DEFINE                                            #FUN-BB0036
      tm      RECORD
               yy         LIKE atc_file.atc06,     #No.FUN-680098     SMALLINT
               bm         LIKE atc_file.atc07,     #No.FUN-680098     SMALLINT
               em         LIKE atc_file.atc07,     #No.FUN-680098     SMALLINT
               ver        LIKE asr_file.asr17,     #FUN-750058
               asa01      LIKE asa_file.asa01,
               asa02      LIKE asa_file.asa01,
               asa03      LIKE asa_file.asa01,
               asa06      LIKE asa_file.asa06,   #FUN-A90026 
               q1         LIKE type_file.chr1,   #FUN-A90026
               h1         LIKE type_file.chr1    #FUN-A90026
              END RECORD,
     g_aaa04        LIKE type_file.num5,   #現行會計年度 #No.FUN-680098  SMALLINT
     g_aaa05        LIKE type_file.num5,   #現行期別     #No.FUN-680098  SMALLINT
     g_aaa07        LIKE aaa_file.aaa07,   #關帳日期
     g_bookno       LIKE aea_file.aea00,   #帳別
     l_flag         LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
     g_change_lang  LIKE type_file.chr1    #No.FUN-680098 VARCHAR(1)    
DEFINE g_dbs_asg03    LIKE type_file.chr21   #FUN-920076
DEFINE g_plant_asg03  LIKE type_file.chr21   #FUN-A30122
DEFINE g_asg03        LIKE asg_file.asg03    #FUN-920076
DEFINE g_aaz641       LIKE aaz_file.aaz641   #FUN-920076
DEFINE g_sql          STRING                 #FUN-920076
DEFINE g_asa06        LIKE asa_file.asa06    
#No.TQC-C90057  --Begin
#DEFINE g_aaz113        LIKE aaz_file.aaz113    #FUN-AA0093
DEFINE g_asz05        LIKE asz_file.asz05
#No.TQC-C90057  --End  

MAIN
#     DEFINE    l_time LIKE type_file.chr8    #No.FUN-6A0073
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_bookno = ARG_VAL(1)
  #->No:FUN-570145 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
#--FUN-A90026 mark---
#   LET tm.yy    = ARG_VAL(2)
#   LET tm.bm    = ARG_VAL(3)
#   LET tm.em    = ARG_VAL(4)
#   LET tm.asa01 = ARG_VAL(5)
#   LET tm.asa02 = ARG_VAL(6)
#   LET tm.asa03 = ARG_VAL(7)
#   LET g_bgjob  = ARG_VAL(8)
#   LET tm.ver   = ARG_VAL(9)  #FUN-750058
#--FUN-A90026 mark--

#---FUN-A90026 start--
   LET tm.asa01 = ARG_VAL(1)
   LET tm.asa02 = ARG_VAL(2)
   LET tm.asa03 = ARG_VAL(3)
   LET tm.yy    = ARG_VAL(4)
   LET tm.asa06 = ARG_VAL(5)
   LET tm.em    = ARG_VAL(6)
   LET tm.q1    = ARG_VAL(7)
   LET tm.h1    = ARG_VAL(8)
   LET g_bgjob  = ARG_VAL(9)
#--FUN-A90026 end----
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF
  #->No.FUN-570145 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
  
   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF              #FUN-570145
  
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
     #SELECT aaz64 INTO g_bookno FROM aaz_file                    #TQC-CB0085 mark
      SELECT asz01 INTO g_bookno FROM asz_file WHERE asz00 = '0'  #TQC-CB0085
   END IF
   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF   #FUN-760044 add
 
#NO.FUN-57045 START-- 
   #CALL gglp301_tm(0,0)
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL gglp301_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p002()
#           CALL p002_ins_ver()                   #寫入版本為tm.em的資料   #FUN-770069 add  #FUN-980067 MARK
           CALL s_showmsg()                      #NO.FUN-710023
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag   #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag   #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW gglp301_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p002()
        CALL s_showmsg()                       #NO.FUN-710023
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END  IF
   END WHILE
#->No.FUN-570145 ---end---
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION gglp301_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,         #No.FUN-680098 SMALLINT
           l_cnt          LIKE type_file.num5,         #No.FUN-680098 SMALLINT
           lc_cmd         LIKE type_file.chr1000       #FUN-570145    #No.FUN-680098   VARCHAR(500)  
   DEFINE  l_asa09        LIKE asa_file.asa09          #FUN-A30064
   DEFINE  l_aznn01       LIKE aznn_file.aznn01         #FUN-A90026 
   DEFINE  l_asg03        LIKE asg_file.asg03          #CHI-B10030 add
   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 5 LET p_col = 30
 
   OPEN WINDOW gglp301_w AT p_row,p_col WITH FORM "ggl/42f/gglp301" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
 
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Defaealt condition
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07 
             FROM aaa_file WHERE aaa01 = g_bookno
      LET tm.yy = g_aaa04
     #LET tm.bm = g_aaa05           #FUN-950048
      LET tm.bm = 0                 #FUN-950048 
      DISPLAY tm.bm TO FORMONLY.bm  #FUN-950048 
      LET tm.em = g_aaa05
      LET tm.ver = '00'        #FUN-760044 add
      LET g_bgjob = 'N'        #No.FUN-570145     
#      INPUT BY NAME tm.yy,tm.bm,tm.em,tm.ver,tm.asa01,tm.asa02,tm.asa03,g_bgjob  #NO.FUN-570145  #FUN-750058
      #INPUT BY NAME tm.yy,tm.bm,tm.em,tm.ver,tm.asa01,tm.asa02,g_bgjob  #NO.FUN-570145  #FUN-750058   #FUN-920076 #FUN-950048 mark
      #INPUT BY NAME tm.yy,tm.em,tm.ver,tm.asa01,tm.asa02,g_bgjob  #NO.FUN-570145  #FUN-750058   #FUN-920076  #FUN-950048 #FUN-A90026 mark
      INPUT BY NAME tm.asa01,tm.asa02,tm.yy,tm.asa06,tm.em,tm.q1,tm.h1,g_bgjob  #FUN-A90026
            WITHOUT DEFAULTS 
 
         #-----MOD-6A0039---------
         #AFTER FIELD yy    
         #   IF NOT cl_null(tm.yy) THEN
         #      IF tm.yy < YEAR(g_aaa07) THEN 
         #         CALL cl_err('','agl-085',0) NEXT FIELD yy 
         #      END IF
         #   END IF
         #   
         #AFTER FIELD bm    
         #   IF NOT cl_null(tm.bm) THEN
         #      IF tm.yy=YEAR(g_aaa07) AND tm.bm < MONTH(g_aaa07) THEN 
         #         CALL cl_err('','agl-085',0) NEXT FIELD bm 
         #      END IF
         #   END IF
         #-----END MOD-6A0039-----
            
         AFTER FIELD em    
            IF NOT cl_null(tm.em) THEN
               IF tm.bm >tm.em  THEN 
                  CALL cl_err('','9011',0) NEXT FIELD em 
               END IF
            END IF
 
         AFTER FIELD asa01
            IF NOT cl_null(tm.asa01) THEN
              #SELECT asa01 FROM asa_file WHERE asa01=tm.asa01            #FUN-580063
               SELECT DISTINCT asa01 FROM asa_file WHERE asa01=tm.asa01   #FUN-580063
               IF STATUS THEN
#                 CALL cl_err(tm.asa01,'agl-117',0)     #No.FUN-660123
                  CALL cl_err3("sel","asa_file",tm.asa01,"","agl-117","","",0)   #No.FUN-660123
                  NEXT FIELD asa01
               END IF
            END IF
#FUN-A30122 ------------------mark start----------------------------------- 
#          str MOD-A20028 add
#           IF NOT cl_null(tm.asa02) THEN
#              SELECT COUNT(*) INTO l_cnt FROM asa_file 
#               WHERE asa01=tm.asa01 AND asa02=tm.asa02
#              IF l_cnt = 0  THEN 
#                 CALL cl_err('sel asa:','agl-118',0) NEXT FIELD asa02 
#              ELSE
#                 SELECT DISTINCT asa03 INTO tm.asa03 FROM asa_file
#                  WHERE asa01=tm.asa01  
#                    AND asa02=tm.asa02  
#                 DISPLAY tm.asa03 TO asa03
#                 #上層公司編號在agli009中所設定工廠/DB
#                 SELECT asg03 INTO g_asg03 FROM asg_file
#                  WHERE asg01 = tm.asa02
##No.FUN-A30064  ---start---
#                 SELECT asa09 INTO l_asa09 FROM asa_file
#                  WHERE asa01 = tm.asa01
#                    AND asa02 = tm.asa02
#                    AND asa03 = tm.asa03
#                 IF l_asa09 = 'Y' THEN
#                    LET g_dbs_asg03 = s_dbstring(g_asg03)
#                 ELSE
#                    LET g_dbs_asg03 = s_dbstring(g_dbs)
#                 END IF 
##No.FUN-A30064 ---end ---
#                 LET g_plant_new = g_asg03      #營運中心
#                 CALL s_getdbs()
#                 LET g_dbs_asg03 = g_dbs_new    #上層公司所屬DB
#                 #上層公司所屬合併帳別
#                 #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",
#                 LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_asg03,'aaz_file'), #FUN-A50102
#                             " WHERE aaz00 = '0'"
#                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
#              CALL cl_parse_qry_sql(g_sql,g_asg03) RETURNING g_sql #FUN-A50102            
#                 PREPARE p002_pre_00 FROM g_sql
#                 DECLARE p002_cur_00 CURSOR FOR p002_pre_00
#                 OPEN p002_cur_00
#                 FETCH p002_cur_00 INTO g_aaz641   #合併帳別
#                 CLOSE p002_cur_00
#              END IF
#           END IF
#          #end MOD-A20028 add
#FUN-A30122 ---------------------------mark end------------------------------------------

#FUN-A30122 --------------------------add start---------------------------------------- 
#         ON CHANGE asa02                                                        
          AFTER FIELD asa02   #FUN-A90026
            IF NOT cl_null(tm.asa02) THEN                                       
               SELECT count(*) INTO l_cnt FROM asa_file                         
               WHERE asa01=tm.asa01 AND asa02=tm.asa02                          
               IF l_cnt = 0  THEN                                               
                  CALL cl_err('sel asa:','agl-118',0) NEXT FIELD asa02          
               ELSE                                                             
                  SELECT DISTINCT asa03 INTO tm.asa03 FROM asa_file             
                  WHERE asa01=tm.asa01                                          
                  AND asa02=tm.asa02                                            
               END IF                                                           
               DISPLAY tm.asa03 TO asa03                                        
               CALL s_aaz641_asg(tm.asa01,tm.asa02) RETURNING g_plant_asg03       
               CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_aaz641                
            END IF 
            #--FUN-A90026 start-- 
            LET g_asa06 = '2'
            SELECT asa06 
              INTO g_asa06  #編制合併期別 1.月 2.季 3.半年 4.年
             FROM asa_file
            WHERE asa01 = tm.asa01     #族群編號
              AND asa04 = 'Y'   #最上層公司否
            LET tm.asa06 = g_asa06
            DISPLAY BY NAME tm.asa06

            CALL p001_set_no_entry()

            IF tm.asa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET tm.em = g_aaa05
            END IF
            IF tm.asa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.asa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.asa06 = '4' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
                let tm.h1 = ''
            END IF
            DISPLAY BY NAME tm.em
            DISPLAY BY NAME tm.q1
            DISPLAY BY NAME tm.h1
            #---FUN-A90026 end---

#FUN-A30122 ------------------------add end--------------------------------

#FUN-A30122 ------------------------mark start----------------------------
#        AFTER FIELD asa02  #公司編號
#           IF NOT cl_null(tm.asa02) THEN
#              SELECT count(*) INTO l_cnt FROM asa_file 
#               WHERE asa01=tm.asa01 AND asa02=tm.asa02
#                  IF l_cnt = 0  THEN 
#                     CALL cl_err('sel asa:','agl-118',0) NEXT FIELD asa02 
#                  #--FUN-920076 start--
#                  ELSE
#                     SELECT DISTINCT asa03 INTO tm.asa03 FROM asa_file
#                      WHERE asa01=tm.asa01  
#                        AND asa02=tm.asa02  
#                     DISPLAY tm.asa03 TO asa03
#                     #上層公司編號在agli009中所設定工廠/DB
#                     SELECT asg03 INTO g_asg03 FROM asg_file
#                      WHERE asg01 = tm.asa02
#No.FUN-A30064 ---start----
#                     SELECT asa09 INTO l_asa09 FROM asa_file
#                      WHERE asa01 = tm.asa01
#                        AND asa02 = tm.asa02
#                        AND asa03 = tm.asa03
#                     IF l_asa09 = 'Y' THEN
#                        LET g_dbs_asg03 = s_dbstring(g_asg03)
#                     ELSE
#                        LET g_dbs_asg03 = s_dbstring(g_dbs)
#                     END IF  
#No.FUN-A30064 ---end---
#                     LET g_plant_new = g_asg03      #營運中心
#                     CALL s_getdbs()
#                     LET g_dbs_asg03 = g_dbs_new    #上層公司所屬DB
#                     
#                     #上層公司所屬合併帳別
#                     #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",
#                     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_asg03,'aaz_file'), #FUN-A50102
#                                 " WHERE aaz00 = '0'"
#                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
#                  CALL cl_parse_qry_sql(g_sql,g_asg03) RETURNING g_sql #FUN-A50102               
#                     PREPARE p002_pre_01 FROM g_sql
#                     DECLARE p002_cur_01 CURSOR FOR p002_pre_01
#                     OPEN p002_cur_01
#                     FETCH p002_cur_01 INTO g_aaz641   #合併帳別
#                     CLOSE p002_cur_01
#                  #--FUN-920076 end------------------------   
#                  END IF
#           END IF
#FUN-A30122 --------------------------mark end------------------------------------------------
 
#--FUN-920076 mark---
#         AFTER FIELD asa03  #帳別 
#            IF NOT cl_null(tm.asa03) THEN
#               SELECT count(*) INTO l_cnt FROM asa_file 
#                WHERE asa01=tm.asa01 AND asa02=tm.asa02 AND asa03=tm.asa03
#                   IF l_cnt = 0  THEN 
#                      CALL cl_err('sel asa:','agl-118',0) NEXT FIELD asa03 
#                   END IF
#            END IF
#--FUN-920076 mark-----
            
         #--MOD-A40192 start--   
         AFTER INPUT
            IF (NOT cl_null(tm.asa01) AND NOT cl_null(tm.asa02)) THEN  #TQC-AA0098
                CALL s_aaz641_asg(tm.asa01,tm.asa02) RETURNING g_dbs_asg03
                CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_aaz641
            END IF             #TQC-AA0098
         #--MOD-A40192 end----
         #--FUN-A90026 start--
            IF NOT cl_null(tm.asa06) THEN
               #CHI-B10030 add --start--
               IF tm.asa06 MATCHES '[234]' THEN      
                     CALL s_asg03_dbs(tm.asa02) RETURNING l_asg03 
                     CALL s_get_aznn01(l_asg03,tm.asa06,tm.asa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
               END IF
               #CHI-B10030 add --end--
               #CHI-B10030 mark --start--
               #CASE
               #    WHEN tm.asa06 = '2'  #季 
               #         SELECT MAX(aznn01) INTO l_aznn01
               #           FROM aznn_file
               #          WHERE aznn00 = tm.asa03
               #            AND aznn02 = tm.yy
               #            AND aznn03 = tm.q1
               #         LET tm.em = MONTH(l_aznn01)
               #    WHEN tm.asa06 = '3'  #半年
               #         IF tm.h1 = '1' THEN  #上半年
               #             SELECT MAX(aznn01) INTO l_aznn01
               #               FROM aznn_file
               #              WHERE aznn00 = tm.asa03
               #                AND aznn02 = tm.yy
               #                AND aznn03 < 3
               #         ELSE                 #下半年
               #             SELECT MAX(aznn01) INTO l_aznn01
               #               FROM aznn_file
               #              WHERE aznn00 = tm.asa03
               #                AND aznn02 = tm.yy
               #                AND aznn03 >='3' #大於等於第三季
               #         END IF
               #         LET tm.em = MONTH(l_aznn01)
               #    WHEN tm.asa06 = '4'  #年
               #         SELECT MAX(aznn01) INTO l_aznn01
               #           FROM aznn_file
               #          WHERE aznn00 = tm.asa03
               #            AND aznn02 = tm.yy
               #         LET tm.em = MONTH(l_aznn01)
               #END CASE
               #CHI-B10030 mark --end--
            END IF
         #--FUN-A90026

         #ON ACTION CONTROLZ    #TQC-C40010  mark
         ON ACTION CONTROLR     #TQC-C40010  add
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asa"
                  LET g_qryparam.default1 = tm.asa01
                  CALL cl_create_qry() RETURNING tm.asa01,tm.asa02,tm.asa03
                  DISPLAY BY NAME tm.asa01,tm.asa02,tm.asa03
                  NEXT FIELD asa01
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
   
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_init()
            CALL p001_set_entry()    #FUN-A90026
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         #->FUN-570145-start----------
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()               #No.FUN-550037 hmf
            LET g_change_lang = TRUE
            EXIT INPUT
         #->FUN-570145-end------------
 
      END INPUT
  #->FUN-570145-start------------
  #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()               #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gglp301_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
#      IF cl_sure(21,21) THEN
#         CALL cl_wait()
#         #期末結轉(END OF MONTH)
#         LET g_success = 'Y'
##         BEGIN WORK
#         CALL p002()
#            IF g_success='Y' THEN
#               COMMIT WORK
#               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#            ELSE
#               ROLLBACK WORK
#               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#            END IF
#            IF l_flag THEN
#               CONTINUE WHILE
#            ELSE
#               EXIT WHILE
#            END IF
#      END  IF
#      ERROR ""
#   END WHILE
#   CLOSE WINDOW gglp301_w
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01= 'gglp301'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('gglp301','9031',1)   
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " ''",
                     #--FUN-A90026 mark--
                     #" '",tm.yy CLIPPED,"'",
                     #" '",tm.bm CLIPPED,"'",
                     #" '",tm.em CLIPPED,"'",
                     #" '",tm.asa01 CLIPPED,"'",
                     #" '",tm.asa02 CLIPPED,"'",
                     #" '",tm.asa03 CLIPPED,"'",
                     #" '",g_bgjob CLIPPED,"'",
                     #" '",tm.ver CLIPPED,"'"  #FUN-750058
                     #--FUN-A90026 mark---
                     #--FUN-A90026 start--
                     " '",tm.asa01 CLIPPED,"'",
                     " '",tm.asa02 CLIPPED,"'",
                     " '",tm.asa03 CLIPPED,"'",
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.asa06 CLIPPED,"'",
                     " '",tm.em CLIPPED,"'",
                     " '",tm.q1 CLIPPED,"'",
                     " '",tm.h1 CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
                     #--FUN-A90026 end---
                     
        CALL cl_cmdat('gglp301',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW gglp301_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM
  END IF
  EXIT WHILE
  #No.FUN-570145 ---end---
  ERROR ""
END WHILE
END FUNCTION
 
FUNCTION p002()
DEFINE l_sql       LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(1000)
       l_asj03     LIKE asj_file.asj03,
       l_asj04     LIKE asj_file.asj04,
       l_ask03     LIKE ask_file.ask03,
       l_ask05     LIKE ask_file.ask05,          #FUN-910023 add
       l_ask06     LIKE ask_file.ask06,
       l_ask07     LIKE ask_file.ask07,
       l_asj21     LIKE asj_file.asj21,          #FUN-750058
       l_asg06     LIKE asg_file.asg06,
       l_asj08     LIKE asj_file.asj08,          #TQC-CA0063
       l_aag04     LIKE aag_file.aag04           #TQC-CA0063
#111102 lilingyu --begin--
DEFINE l_ass00     LIKE ass_file.ass00
DEFINE l_ass01     LIKE ass_file.ass01
DEFINE l_ass02     LIKE ass_file.ass02
DEFINE l_ass03     LIKE ass_file.ass03
DEFINE l_ass05     LIKE ass_file.ass05
DEFINE l_ass06     LIKE ass_file.ass06
DEFINE l_ass07     LIKE ass_file.ass07
DEFINE l_ass08     LIKE ass_file.ass08
DEFINE l_ass09     LIKE ass_file.ass09
DEFINE l_ass10     LIKE ass_file.ass10
DEFINE l_ass11     LIKE ass_file.ass11
DEFINE l_ass12     LIKE ass_file.ass12
DEFINE l_ass13     LIKE ass_file.ass13
DEFINE l_ass15     LIKE ass_file.ass15
DEFINE l_asslegal  LIKE ass_file.asslegal
#111102 lilingyu --end-- 
       
  #LET g_bookno=tm.asa03     #FUN-630063
  LET g_bookno=g_aaz641     #FUN-920076
  
  LET l_asg06=''
  SELECT asg06 INTO l_asg06 FROM asg_file WHERE asg01=tm.asa02
 
  ##atc_file :合併後會計科目各期餘額檔
  ##atcc_file:合併後科目異動碼沖帳餘額檔
  
##step 1 刪除資料
##delete atc_file
  DELETE FROM atc_file 
      WHERE atc00=g_bookno 
        AND atc01=tm.asa01 AND atc02=tm.asa02 AND atc03=tm.asa03
        AND atc04=tm.asa02            #No:9705
        #AND atc06=tm.yy AND atc07 BETWEEN tm.bm AND tm.em  #FUN-980067 mark
        AND atc06=tm.yy AND atc07 = tm.em    #FUN-980067 mod  
       #AND atc13=tm.ver  #FUN-750058        #FUN-770069 mark
        AND (atc13=tm.ver OR atc13=tm.em)    #FUN-770069
        AND atc12=l_asg06                    #FUN-930117
 #str FUN-910023 add
  DELETE FROM atcc_file 
      WHERE atcc00=g_bookno 
        AND atcc01=tm.asa01 AND atcc02=tm.asa02 AND atcc03=tm.asa03
        AND atcc04=tm.asa02
        #AND atcc08=tm.yy AND atcc09 BETWEEN tm.bm AND tm.em  #FUN-980067 mark
        AND atcc08=tm.yy AND atcc09 = tm.em      #FUN-980067
        AND (atcc15=tm.ver OR atcc15=tm.em)
        AND atcc14 = l_asg06    #FUN-930117
 #end FUN-910023 add
#FUN-9B0017   ---start
  DELETE FROM asll_file
   WHERE asll00=g_bookno
#    AND asll01=tm.asa01 AND asll02=tm.asa02 AND asll03=tm.asa03  #FUN-A10015
     AND asll01=tm.asa01 AND asll02=tm.asa02 AND asll021=tm.asa03 #FUN-A10015
#    AND asll04=tm.asa02                                          #FUN-A10015
     AND asll03=tm.asa02                                          #FUN-A10015
#    AND asll08=tm.yy AND asll09 = tm.em     #No.MOD-CA0069
     AND asll09=tm.yy AND asll10 = tm.em     #FUN-AA0093
#    AND (asll15=tm.ver OR asll15=tm.em)                          #FUN-A10015
#    AND asll14 = l_asg06                                         #FUN-A10015
     AND asll18 = l_asg06                                         #FUN-A10015
#FUN-9B0017   ---end
  
##step 2 資料匯入
##asr_file->atc_file
  #FUN-AA0093 start--
#No.TQC-C90057  --Begin
# SELECT aaz113 INTO g_aaz113
#   FROM aaz_file
#  WHERE aaz00 = '0'
  SELECT asz05  INTO g_asz05 
    FROM asz_file
   WHERE asz00 = '0'
#No.TQC-C90057  --End  
  #FUN-AA0093 end---
  INSERT INTO atc_file(atc00,atc01,atc02,atc03,atc04,atc041,
                       atc05,atc06,atc07,atc12,  #FUN-5A0020
                       atc08,atc09,atc10,atc11,atc13,atclegal)  #FUN-750058 #FUN-980003 add legal
       SELECT asr00,asr01,asr02,asr03,asr02,asr03,asr05,asr06,asr07,
              asg06,   #FUN-5A0020
              SUM(asr08),SUM(asr09),SUM(asr10),SUM(asr11),asr17,asrlegal  #FUN-750058 #FUN-980003 add asrlegal
         FROM asr_file
             ,asg_file   #FUN-5A0020
        WHERE asr01=tm.asa01 AND asr02=tm.asa02 AND asr03=tm.asa03
          AND asr06=tm.yy                   #No.MOD-470574 (atc 改 asr)
#         AND asr07 between tm.bm and tm.em #No:9705 #No.MOD-470574(atc改asr)  #FUN-980067 mark
          AND asr07 = tm.em #FUN-980067 mod    
         #AND asr01=asg01   #MOD-740252 mark
          AND asr02=asg01   #MOD-740252
          AND asr00=g_aaz641  #FUN-5A0020   #FUN-920076
          #AND asr00=tm.asa03  #FUN-5A0020
          AND asr17=tm.ver  #FUN-750058
          AND asr12=asg06   #FUN-750058
          #No.TQC-C90057  --Begin
          #AND asr05 <> g_aaz113   #FUN-AA0093
          AND asr05 <> g_asz05
          #No.TQC-C90057  --End  
        GROUP BY asr00,asr01,asr02,asr03,asr02,asr03,asr05,asr06,asr07
                ,asg06,asr17,asrlegal   #FUN-750058 #FUN-980003 add asrlegal
  IF SQLCA.sqlcode THEN 
     LET g_success= 'N'
#    CALL cl_err('ins atc_file(1)',SQLCA.sqlcode,0)   #No.FUN-660123
     CALL cl_err3("ins","atc_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","ins atc_file(1)",0)   #No.FUN-660123 
     RETURN                                                                                  #NO.FUN-710023       
  END IF

#111102 lilingyu --begin--  
# #str FUN-910023 add 
#  INSERT INTO atcc_file(atcc00,atcc01,atcc02,atcc03,atcc04,atcc041,
#                        atcc05,atcc06,atcc07,atcc08,atcc09,atcc10,
#                        atcc11,atcc12,atcc13,atcc14,atcc15,atcclegal) #MOD-9C0421
#       SELECT ass00,ass01,ass02,ass03,ass02,ass03,
#              ass05,ass06,ass07,ass08,ass09,
#              SUM(ass10),SUM(ass11),SUM(ass12),SUM(ass13),
#              asg06,ass15,asslegal    #MOD-9C0421
#         FROM ass_file,asg_file
#        WHERE ass01=tm.asa01 AND ass02=tm.asa02 AND ass03=tm.asa03
#          AND ass08=tm.yy
#          #AND ass09 between tm.bm and tm.em  #FUN-980067 mark
#           AND ass09 = tm.em   #FUN-980067
#          AND ass02=asg01
#          #AND ass00=tm.asa03
#          AND ass00=g_aaz641   #FUN-920076
#          AND ass15=tm.ver
#          AND ass14=asg06
#          AND ass05 <> g_aaz113   #FUN-AA0093
#        GROUP BY ass00,ass01,ass02,ass03,ass02,ass03,
#                 ass05,ass06,ass07,ass08,ass09,asg06,ass15,asslegal  #MOD-9C0421


       SELECT DISTINCT ass00,ass01,ass02,ass03,ass02,ass03,
              ass05,ass06,ass07,ass08,ass09,
              SUM(ass10),SUM(ass11),SUM(ass12),SUM(ass13),
              asg06,ass15,asslegal   
          INTO l_ass00,l_ass01,l_ass02,l_ass03,l_ass02,l_ass03,
               l_ass05,l_ass06,l_ass07,l_ass08,l_ass09,
               l_ass10,l_ass11,l_ass12,l_ass13,
               l_asg06,l_ass15,l_asslegal            
         FROM ass_file,asg_file
        WHERE ass01=tm.asa01 AND ass02=tm.asa02 AND ass03=tm.asa03
          AND ass08=tm.yy
           AND ass09 = tm.em 
          AND ass02=asg01
          AND ass00=g_aaz641  
          AND ass15=tm.ver
          AND ass14=asg06
          #No.TQC-C90057  --Begin
          #AND ass05 <> g_aaz113  
          AND ass05 <> g_asz05
          #No.TQC-C90057  --End  
          AND rownum = 1 
        GROUP BY ass00,ass01,ass02,ass03,ass02,ass03,
                 ass05,ass06,ass07,ass08,ass09,asg06,ass15,asslegal     

       IF cl_null(l_asslegal) THEN LET l_asslegal = g_legal END IF  
       IF cl_null(l_ass08)    THEN LET l_ass08    = 0       END IF 
       IF cl_null(l_ass09)    THEN LET l_ass09    = 0       END IF                         
                      
     INSERT INTO atcc_file(atcc00,atcc01,atcc02,atcc03,atcc04,atcc041,
                           atcc05,atcc06,atcc07,atcc08,atcc09,atcc10,
                           atcc11,atcc12,atcc13,atcc14,atcc15,atcclegal,
                           atcc16,atcc17,atcc19,atcc20,atcc22)  
            VALUES(l_ass00,l_ass01,l_ass02,l_ass03,l_ass02,l_ass03,
                   l_ass05,l_ass06,l_ass07,l_ass08,l_ass09,
                   l_ass10,l_ass11,l_ass12,l_ass13,
                   l_asg06,l_ass15,l_asslegal,0,0,0,0,' ')                                                                                                          
#111102 lilingyu --end--                 
  IF SQLCA.sqlcode THEN
     LET g_success= 'N'
     CALL cl_err3("ins","atcc_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","ins atcc_file(1)",0)
     RETURN
  END IF
 #end FUN-910023 add
 
#FUN-A10015 --Beatk
  INSERT INTO asll_file(asll00,asll01,asll02,asll021,asll03,asll031,asll04,
                        asll05,asll06,asll07,asll08,asll09,asll10,asll11,
                        asll12,asll13,asll14,asll15,asll16,asll17,asll18,aslllegal)
       SELECT asl00,asl01,asl02,asl021,asl02,asl021,asl04,   #MOD-AC0232 
       #SELECT asl00,asl01,asl02,asl021,asl03,asl031,asl04,
              asl05,asl06,asl07,asl08,asl09,asl10,
              SUM(asl11),SUM(asl12),SUM(asl13),SUM(asl14),
             #asl15,asl16,asl17,asg06,asllegal                #TQC-B20178 mark
             #asl15,asl16,'0',asg06,asllegal                   #TQC-B20178 mod   #MOD-B80141 mark
              asl15,'0','0',asg06,asllegal                     #MOD-B80141 add
         FROM asl_file,asg_file
        WHERE asl01=tm.asa01 AND asl02=tm.asa02 AND asl021=tm.asa03
          AND asl09=tm.yy
          AND asl10 = tm.em
          AND asl02=asg01
          AND asl00=g_aaz641
          AND asl15=tm.ver
          AND asl18=asg06
        GROUP BY asl00,asl01,asl02,asl021,asl02,asl021,asl04,    #MOD-AC0232
        #GROUP BY asl00,asl01,asl02,asl021,asl03,asl031,asl04,
                #asl05,asl06,asl07,asl08,asl09,asl10,asl15,asl16,asl17,asg06,asllegal   #TQC-B20178 mark
                #asl05,asl06,asl07,asl08,asl09,asl10,asl15,asl16,asg06,asllegal         #TQC-B20178 mod #MOD-B80141 mark
                 asl05,asl06,asl07,asl08,asl09,asl10,asl15,asg06,asllegal               #MOD-B80141 add
  IF SQLCA.sqlcode THEN
     LET g_success= 'N'
     CALL cl_err3("ins","asll_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","ins asll_file(1)",0)
     RETURN
  END IF
#FUN-A10015 --End
 
##step 3 調整分錄資料更新合併資料
##ref.dbo.asj_file and ask_file update atc_file
 
  #LET l_sql=" SELECT asj03,asj04,ask03,ask06,SUM(ask07),asj21 ", #FUN-750058    #TQC-CA0063 mark
  LET l_sql=" SELECT asj03,asj04,ask03,ask06,asj08,SUM(ask07),asj21 ",           #TQC-CA0063 add asj08
            "  FROM asj_file,ask_file ",
            " WHERE asj01=ask01 AND asj00= '",g_bookno,"' ",
            "  AND  asj00=ask00                           ",
            "  AND asj03=",tm.yy,
            #"  AND asj04 BETWEEN ",tm.bm," AND ",tm.em, #FUN-980067 mark
             "  AND asj04 = ",tm.em,   #FUN-980067 add     
            "  AND asj05='",tm.asa01,"' AND asj06='",tm.asa02,"'",
            "  AND asj07='",tm.asa03,"'",
            "  AND asjconf='Y' ",
            "  AND asj21='",tm.ver,"'",  #FUN-750058
            "  AND asj08 <> '1'",        #FUN-A90026 
            #No.TQC-C90057  --Begin
            #"  AND ask03 <> '",g_aaz113,"'",  #FUN-AA0093
            "  AND ask03 <> '",g_asz05 ,"'", 
            #No.TQC-C90057  --End  
            #" GROUP BY asj03,asj04,ask03,ask06,asj21 "  #FUN-750058        #TQC-CA0063 mark
            " GROUP BY asj03,asj04,ask03,ask06,asj08,asj21 "                #TQC-CA0063 add asj08
            
  PREPARE p002_asj_p FROM l_sql
  IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
     CALL cl_batch_bg_javamail('N')        #FUN-570145  
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM 
  END IF
  DECLARE p002_asj_c CURSOR FOR p002_asj_p
  CALL s_showmsg_init()                            #NO.FUN-710023
  #FOREACH p002_asj_c INTO l_asj03,l_asj04,l_ask03,l_ask06,l_ask07,l_asj21  #FUN-750058        #TQC-CA0063 mark
  FOREACH p002_asj_c INTO l_asj03,l_asj04,l_ask03,l_ask06,l_asj08,l_ask07,l_asj21              #TQC-CA0063 
#NO.FUN-710023--BEGIN                                                           
     IF g_success='N' THEN                                                    
       LET g_totsuccess='N'                                                   
       LET g_success='Y'                                                      
     END IF  
#NO.FUN-710023--END
     IF SQLCA.sqlcode THEN 
#       CALL cl_err('p002_asj_c',SQLCA.sqlcode,0)    #NO.FUN-710023
        LET g_showmsg=g_bookno,"/",tm.yy,"/",tm.asa01,"/",tm.asa02,"/",tm.asa03,"/","Y"
        CALL s_errmsg('asj00,asj03,asj05,asj06,asj07,asjconf',g_showmsg,'p002_asj_c',SQLCA.sqlcode,0) 
        LET g_success ='N' #FUN-8A0086
        EXIT FOREACH 
     END IF 
     #TQC-CA0063--start
     LET l_aag04 = ' '
     SELECT aag04 INTO l_aag04
      FROM aag_file
     WHERE aag00 = g_bookno
        AND aag01 = l_ask03
     IF l_aag04 = '2' AND l_asj08 = '4' THEN
        CONTINUE FOREACH
     END IF
     #TQC-CA0063--end

     CASE 
        WHEN l_ask06='1'
           UPDATE atc_file SET atc08=atc08+l_ask07 
            WHERE atc00=g_bookno AND atc01=tm.asa01 
              AND atc02=tm.asa02 AND atc03=tm.asa03
              AND atc04=tm.asa02 AND atc041=tm.asa03 
              AND atc06=l_asj03  AND atc07=l_asj04
              AND atc05=l_ask03 
              AND atc12=l_asg06  #FUN-750058
              AND atc13=l_asj21  #FUN-750058
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
              INSERT INTO atc_file(atc00,atc01,atc02,atc03,atc04,atc041,  #No.MOD-470041
                                   atc05,atc06,atc07,atc08,atc09,atc10,
                                   atc11,atc12,atc13,atclegal)   #FUN-750058 #FUN-980003 add atclegal
                  VALUES(g_bookno,tm.asa01,tm.asa02,tm.asa03,tm.asa02,
                         tm.asa03,l_ask03,l_asj03,l_asj04,
                         l_ask07,0,1,0,l_asg06,l_asj21,g_legal) #FUN-750058 #FUN-980003 add legal
              IF SQLCA.sqlcode THEN 
#                CALL cl_err('ins atc_file(2)',SQLCA.sqlcode,0)   #No.FUN-660123
#                CALL cl_err3("ins","atc_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","ins atc_file(2)",0)   #No.FUN-660123  #NO.FUN-710023
                 LET g_showmsg=tm.asa01,"/",tm.asa02,"/",tm.asa03 
                 CALL s_errmsg('atc01,atc02,atc03',g_showmsg,'ins atc_file(2)',SQLCA.sqlcode,1)          #NO.FUN-710023
                 LET g_success = 'N'    
#                RETURN                                                                                  #NO.FUN-710023 
                 CONTINUE FOREACH                                                                        #NO.FUN-710023 
              END IF
           END IF
        WHEN l_ask06='2'
           UPDATE atc_file SET atc09=atc09+l_ask07 
            WHERE atc00=g_bookno and atc01=tm.asa01 
              and atc02=tm.asa02 and atc03=tm.asa03
              and atc04=tm.asa02 and atc041=tm.asa03 
              and atc06=l_asj03 and atc07=l_asj04
              and atc05=l_ask03
              AND atc12=l_asg06  #FUN-750058
              AND atc13=l_asj21  #FUN-750058
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
              INSERT INTO atc_file(atc00,atc01,atc02,atc03,atc04,atc041,  #No.MOD-470041
                                   atc05,atc06,atc07,atc08,atc09,atc10,
                                   atc11,atc12,atc13,atclegal)  #FUN-750058 #FUN-980003 add atclegal
                  VALUES(g_bookno,tm.asa01,tm.asa02,tm.asa03,tm.asa02,
                         tm.asa03,l_ask03,l_asj03,l_asj04,
                         0,l_ask07,0,1,l_asg06,l_asj21,g_legal)  #FUN-980003 add g_legal
              IF SQLCA.sqlcode THEN 
#                CALL cl_err('ins atc_file(3)',SQLCA.sqlcode,0)   #No.FUN-660123
#                CALL cl_err3("ins","atc_file",tm.asa01,tm.asa02,SQLCA.sqlcode,"","ins atc_file(3)",0)   #No.FUN-660123 #NO.FUN-710023
                 LET g_showmsg=tm.asa01,"/",tm.asa02,"/",tm.asa03 
                 CALL s_errmsg('atc01,atc02,atc03',g_showmsg,'ins atc_file(2)',SQLCA.sqlcode,1)          #NO.FUN-710023
                 LET g_success = 'N' 
#                RETURN                                                                                  #NO.FUN-710023 
                 CONTINUE FOREACH                                                                        #NO.FUN-710023 
              END IF
           END IF
        OTHERWISE EXIT CASE
     END CASE
  END FOREACH
   
 #str FUN-910023 add
  #LET l_sql=" SELECT asj03,asj04,ask03,ask05,ask06,SUM(ask07),asj21 ",         #TQC-CA0063   mark
  LET l_sql=" SELECT asj03,asj04,ask03,ask05,ask06,asj08,SUM(ask07),asj21 ",    #TQC-CA0063  add asj08 
            "  FROM asj_file,ask_file ",
            " WHERE asj01=ask01 AND asj00= '",g_bookno,"' ",
            "  AND  asj00=ask00                           ",
            "  AND asj03=",tm.yy,
            #"  AND asj04 BETWEEN ",tm.bm," AND ",tm.em,  #FUN-980067 mark
             "  AND asj04 = ",tm.em,          #FUN-980067 add
            "  AND asj05='",tm.asa01,"' AND asj06='",tm.asa02,"'",
            "  AND asj07='",tm.asa03,"'",
            "  AND asjconf='Y' ",
            "  AND asj21='",tm.ver,"'",
            "  AND (ask05 IS NOT NULL OR ask05 <> ' ')",  
            "  AND asj08 <> '1'",   #FUN-A90026 
            #No.TQC-C90057  --Begin
            #"  AND ask03 <> '",g_aaz113,"'",   #FUN-AA0093
            "  AND ask03 <> '",g_asz05 ,"'", 
            #No.TQC-C90057  --End  
            #" GROUP BY asj03,asj04,ask03,ask05,ask06,asj21 "                  #TQC-CA0063   mark
            " GROUP BY asj03,asj04,ask03,ask05,ask06,asj08,asj21 "             #TQC-CA0063   

            
  PREPARE p002_asj_p1 FROM l_sql
  IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
     CALL cl_batch_bg_javamail('N')
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM 
  END IF
  DECLARE p002_asj_c1 CURSOR FOR p002_asj_p1
  CALL s_showmsg_init()
  FOREACH p002_asj_c1 INTO l_asj03,l_asj04,l_ask03,l_ask05,
                           #l_ask06,l_ask07,l_asj21                #TQC-CA0063   mark
                           l_ask06,l_asj08,l_ask07,l_asj21         #TQC-CA0063
     IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
     END IF  
     IF SQLCA.sqlcode THEN 
        LET g_showmsg=g_bookno,"/",tm.yy,"/",tm.asa01,"/",tm.asa02,"/",tm.asa03,"/","Y"
        CALL s_errmsg('asj00,asj03,asj05,asj06,asj07,asjconf',g_showmsg,'p002_asj_c1',SQLCA.sqlcode,0) 
        LET g_success ='N'
        EXIT FOREACH 
     END IF 
     #TQC-CA0063--start
     LET l_aag04 = ' '
     SELECT aag04 INTO l_aag04
      FROM aag_file
     WHERE aag00 = g_bookno
       AND aag01 = l_ask03
     IF l_aag04 = '2' AND l_asj08 = '4' THEN
        CONTINUE FOREACH
     END IF
     #TQC-CA0063--end

     CASE 
        WHEN l_ask06='1'
           UPDATE atcc_file SET atcc10=atcc10+l_ask07 
            WHERE atcc00=g_bookno AND atcc01 =tm.asa01 
              AND atcc02=tm.asa02 AND atcc03 =tm.asa03
              AND atcc04=tm.asa02 AND atcc041=tm.asa03 
              AND atcc08=l_asj03  AND atcc09 =l_asj04
              AND atcc05=l_ask03 
              AND atcc14=l_asg06
              AND atcc15=l_asj21
              AND atcc07=l_ask05                        #MOD-A30100
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
              INSERT INTO atcc_file(atcc00,atcc01,atcc02,atcc03,atcc04,atcc041,
                                    atcc05,atcc06,atcc07,atcc08,atcc09,atcc10,
                                    atcc11,atcc12,atcc13,atcc14,atcc15,atcclegal,
                           atcc16,atcc17,atcc19,atcc20,atcc22  #111102 lilingyu add                                    
                                    ) #MOD-9C0421
              VALUES(g_bookno,tm.asa01,tm.asa02,tm.asa03,tm.asa02,tm.asa03,
                     l_ask03,'99',l_ask05,l_asj03,l_asj04,
                     l_ask07,0,1,0,l_asg06,l_asj21,g_legal,
                     0,0,0,0,' '                                #111102 lilingyu add
                     )  #MOD-9C0421 
                     
              IF SQLCA.sqlcode THEN 
                 LET g_showmsg=tm.asa01,"/",tm.asa02,"/",tm.asa03 
                 CALL s_errmsg('atcc01,atcc02,atcc03',g_showmsg,'ins atcc_file(2)',SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 CONTINUE FOREACH
              END IF
           END IF
        WHEN l_ask06='2'
           UPDATE atcc_file SET atcc11=atcc11+l_ask07 
            WHERE atcc00=g_bookno AND atcc01 =tm.asa01 
              AND atcc02=tm.asa02 AND atcc03 =tm.asa03
              AND atcc04=tm.asa02 AND atcc041=tm.asa03 
              AND atcc08=l_asj03  AND atcc09 =l_asj04
              AND atcc05=l_ask03 
              AND atcc14=l_asg06
              AND atcc15=l_asj21
              AND atcc07=l_ask05                        #MOD-A30100
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
              INSERT INTO atcc_file(atcc00,atcc01,atcc02,atcc03,atcc04,atcc041,
                               atcc05,atcc06,atcc07,atcc08,atcc09,atcc10,
                               atcc11,atcc12,atcc13,atcc14,atcc15,atcclegal
                           , atcc16,atcc17,atcc19,atcc20,atcc22)             #111102 lilingyu                                
                                #MOD-9C0421 

              VALUES(g_bookno,tm.asa01,tm.asa02,tm.asa03,tm.asa02,tm.asa03,
                     l_ask03,'99',l_ask05,l_asj03,l_asj04,
                    0,l_ask07,0,1,l_asg06,l_asj21,g_legal,
                    0,0,0,0,' '                                          #111102 lilingyu add
                    )  #MOD-9C0421           
              IF SQLCA.sqlcode THEN 
                 LET g_showmsg=tm.asa01,"/",tm.asa02,"/",tm.asa03 
                 CALL s_errmsg('atcc01,atcc02,atcc03',g_showmsg,'ins atcc_file(2)',SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 CONTINUE FOREACH
              END IF
           END IF
        OTHERWISE EXIT CASE
     END CASE
  END FOREACH  
 #end FUN-910023 add
     
#NO.FUN-710023--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710023--END
END FUNCTION
 
#str FUN-770069 add
#當執行起始/截止期別為1-3時，
#除了會寫入一筆atc13(版本)為00的資料之外，
#還要再寫入一筆atc13(版本)為3(以截止期別為版本)的資料
FUNCTION p002_ins_ver()   
 
  DROP TABLE x
 
  SELECT * FROM atc_file
   WHERE atc00=tm.asa03
     AND atc01=tm.asa01 
     AND atc02=tm.asa02 
     AND atc03=tm.asa03
     AND atc06=tm.yy
     AND atc07 BETWEEN tm.bm AND tm.em
     AND atc13=tm.ver
    INTO TEMP x
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","x", tm.asa01,tm.asa02,SQLCA.sqlcode,"","",1)
     RETURN
  END IF
 
  UPDATE x SET atc13 = tm.em
 
  INSERT INTO atc_file SELECT * FROM x
  IF SQLCA.sqlcode THEN
     LET g_showmsg=tm.asa01,"/",tm.asa02,"/",tm.asa03 
     CALL s_errmsg('atc01,atc02,atc03',g_showmsg,'ins atc_file(3)',SQLCA.sqlcode,1)
     LET g_success = 'N'    
  END IF
 
 #str FUN-910023 add
  DROP TABLE y
  SELECT * FROM atcc_file
   #WHERE atcc00=tm.asa03
   WHERE atcc00=g_aaz641  #FUN-920076 mod
     AND atcc01=tm.asa01 
     AND atcc02=tm.asa02 
     AND atcc03=tm.asa03
     AND atcc08=tm.yy
     AND atcc09 BETWEEN tm.bm AND tm.em
     AND atcc15=tm.ver
    INTO TEMP y
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","y", tm.asa01,tm.asa02,SQLCA.sqlcode,"","",1)
     RETURN
  END IF
  UPDATE y SET atcc15 = tm.em
  INSERT INTO atcc_file SELECT * FROM y
  IF SQLCA.sqlcode THEN
     LET g_showmsg=tm.asa01,"/",tm.asa02,"/",tm.asa03 
     CALL s_errmsg('atcc01,atcc02,atcc03',g_showmsg,'ins atcc_file(3)',SQLCA.sqlcode,1)
     LET g_success = 'N'    
  END IF
 #end FUN-910023 add
 
END FUNCTION
#end FUN-770069 add

#FUN-A90026 start---
FUNCTION p001_set_entry() 
    CALL cl_set_comp_entry("q1,em,h1",TRUE) 
END FUNCTION

FUNCTION p001_set_no_entry() 

      CALL cl_set_comp_entry("asa06",FALSE) 

      IF tm.asa06 ="1" THEN  #月
         CALL cl_set_comp_entry("q1,h1",FALSE) 
      END IF
      IF tm.asa06 ="2" THEN  #季
         CALL cl_set_comp_entry("em,h1",FALSE) 
      END IF
      IF tm.asa06 ="3" THEN  #半年
         CALL cl_set_comp_entry("em,q1",FALSE) 
      END IF
      IF tm.asa06 ="4" THEN  #年
         CALL cl_set_comp_entry("q1,em,h1",FALSE) 
      END IF
END FUNCTION
#--FUN-A90026 end------------------


