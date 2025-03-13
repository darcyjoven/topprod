# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: aglp002.4gl
# Descriptions...: 合併資料產生作業(整批資料處理作業)
# Input parameter: 
# Return code....: 
# Modify.........: No:9705 04/07/09 By Nicola Select條件修改
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-580063 05/09/07 By Sarah 執行會當掉
# Modify.........: No.FUN-5A0020 05/10/06 By Sarah 幣別請塞入上層公司的記帳幣別
# Modify ........: No.FUN-570145 06/02/24 By YITING 批次背景執行
# Modify.........: No.FUN-630063 06/03/22 By ching bookno應是axa03
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.MOD-6A0039 06/10/14 By Smapmin 年度與月份不應受限於aaa07
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/16 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-740252 07/04/27 By Sarah axg_file與axz_file的連接key值應該是axg02=axz01
# Modify.........: No.FUN-750058 07/05/23 By kim 增加版本欄位
# Modify.........: No.FUN-760044 07/06/15 By Sarah 隱藏畫面的版本欄位,計算時寫死抓版本00的資料
# Modify.........: No.FUN-770069 07/07/25 By Sarah 寫入axh_file時,除了寫入版本為00的資料外,要再寫入版本為截止期別(tm.em)的資料
# Modify.........: No.FUN-8A0086 08/10/20 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910023 09/01/08 By Sarah 增加合併後異動碼餘額檔axkk_file
# Modify.........: NO.FUN-930117 09/03/17 BY hongmei pk值異動，相關程式修改
# Modify.........: No.FUN-950048 09/06/08 By hongmei 畫面上的起始期別設為noentry,并且預設為0     
# Modify.........: NO.FUN-920076 09/02/10 BY yiting 1.aglp002在抓取axg_file,axk_file時 ，應以上層公司合併帳別為條件
# Modify.........: NO.FUN-980067 09/10/30 BY yiting aglp002處理時，日期區間改為都抓當月異動
# Modify.........: NO.MOD-9C0421 09/12/29 BY jan axkk_file沒有處理axkklegal
# Modify.........: No:MOD-A20028 10/02/22 By Sarah 調整g_aaz641抓取的時間點
# Modify.........: NO.MOD-A30100 10/03/17 By Dido 調整 UPDATE axkk_file key 值 
# Modify.........: No.FUN-A30064 10/03/30 By vealxu 不做獨立合併會科時，DB取aaz641
# Modify.........: No.FUN-A50102 10/07/27 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.......... NO.MOD-A40192 10/04/30 by yiting 1.在AFTER INPUT重取aaz641 2.insert into axkk_file要只取有關係人的
# Modidy.........: No.FUN-A30122 10/08/23 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No:FUN-9B0017 10/09/01 By chenmoyan 將異動碼科目餘額檔aei_file做滾算至合併前科目異動碼(固定)沖帳餘額檔aeii_file,提供後續部門合併財報使用
# Modify.........: NO.FUN-A10015 10/09/13 By chenmoyan aeii_file表結構異動
# Modify.........: NO.MOD-A40192 10/04/30 by yiting 1.在AFTER INPUT重取aaz641 2.insert into axkk_file要只取有關係人的
# Modify.........: NO.FUN-A90026 10/09/14 BY yiting 2.輸入增加選項
# Modify.........: NO.TQC-AA0098 10/10/16 BY yiting 群組及公司代號都有值時，才call s_aaaz641_dbs
# Modify.........: NO.FUN-AA0093 10/10/28 BY yiting 捲算時應排除本期損益IS科目
# Modify.........: NO.MOD-AC0232 10/12/20 BY yiting insert into aeii_file抓取欄位及GROUP BY 應該都為上層公司
# Modify.........: NO:CHI-B10030 11/01/24 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO:TQC-B20178 11/08/09 BY Belle 寫入aeii_file時不用寫入匯率,待aglp001捲算時再計算 
# Modify.........: NO:MOD-B80141 11/08/16 BY polly 寫入aeii_file時不用寫入aei16，待aglp001捲算時再計算
# Modify.........: No.FUN-BA0012 11/10/05 By Belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.TQC-BA0129 11/10/24 By Belle 將程式中有axi08<>1改為IN('2','3')
# Modify.........: No:MOD-C20100 12/02/14 By Polly 調整刪除aeii_file的條件
# Modify.........: No.FUN-BA0111 12/04/17 By Belle 將總帳的異動碼科餘1~4碼也納入合併資料
# Modify.........: No.MOD-CB0270 12/11/29 By Polly 調整寫入aeii_file寫入的值

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE 
      tm      RECORD
               yy         LIKE axh_file.axh06,     #No.FUN-680098     SMALLINT
               bm         LIKE axh_file.axh07,     #No.FUN-680098     SMALLINT
               em         LIKE axh_file.axh07,     #No.FUN-680098     SMALLINT
               ver        LIKE axg_file.axg17,     #FUN-750058
               axa01      LIKE axa_file.axa01,
               axa02      LIKE axa_file.axa01,
               axa03      LIKE axa_file.axa01,
               axa06      LIKE axa_file.axa06,   #FUN-A90026 
               q1         LIKE type_file.chr1,   #FUN-A90026
               h1         LIKE type_file.chr1    #FUN-A90026
              END RECORD,
     g_aaa04        LIKE type_file.num5,   #現行會計年度 #No.FUN-680098  SMALLINT
     g_aaa05        LIKE type_file.num5,   #現行期別     #No.FUN-680098  SMALLINT
     g_aaa07        LIKE aaa_file.aaa07,   #關帳日期
     g_bookno       LIKE aea_file.aea00,   #帳別
     l_flag         LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1)
     g_change_lang  LIKE type_file.chr1    #No.FUN-680098 VARCHAR(1)    
DEFINE g_dbs_axz03    LIKE type_file.chr21   #FUN-920076
DEFINE g_plant_axz03  LIKE type_file.chr21   #FUN-A30122
DEFINE g_axz03        LIKE axz_file.axz03    #FUN-920076
DEFINE g_aaz641       LIKE aaz_file.aaz641   #FUN-920076
DEFINE g_sql          STRING                 #FUN-920076
DEFINE g_axa06        LIKE axa_file.axa06    
DEFINE g_aaz113        LIKE aaz_file.aaz113    #FUN-AA0093

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
#   LET tm.axa01 = ARG_VAL(5)
#   LET tm.axa02 = ARG_VAL(6)
#   LET tm.axa03 = ARG_VAL(7)
#   LET g_bgjob  = ARG_VAL(8)
#   LET tm.ver   = ARG_VAL(9)  #FUN-750058
#--FUN-A90026 mark--

#---FUN-A90026 start--
   LET tm.axa01 = ARG_VAL(1)
   LET tm.axa02 = ARG_VAL(2)
   LET tm.axa03 = ARG_VAL(3)
   LET tm.yy    = ARG_VAL(4)
   LET tm.axa06 = ARG_VAL(5)
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
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
  
   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF              #FUN-570145
  
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file
   END IF
   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF   #FUN-760044 add
 
#NO.FUN-57045 START-- 
   #CALL aglp002_tm(0,0)
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp002_tm(0,0)
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
              CLOSE WINDOW aglp002_w
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
 
FUNCTION aglp002_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,         #No.FUN-680098 SMALLINT
           l_cnt          LIKE type_file.num5,         #No.FUN-680098 SMALLINT
           lc_cmd         LIKE type_file.chr1000       #FUN-570145    #No.FUN-680098   VARCHAR(500)  
   DEFINE  l_axa09        LIKE axa_file.axa09          #FUN-A30064
   DEFINE  l_aznn01       LIKE aznn_file.aznn01         #FUN-A90026 
   DEFINE  l_axz03        LIKE axz_file.axz03          #CHI-B10030 add
   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 5 LET p_col = 30
 
   OPEN WINDOW aglp002_w AT p_row,p_col WITH FORM "agl/42f/aglp002" 
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
#      INPUT BY NAME tm.yy,tm.bm,tm.em,tm.ver,tm.axa01,tm.axa02,tm.axa03,g_bgjob  #NO.FUN-570145  #FUN-750058
      #INPUT BY NAME tm.yy,tm.bm,tm.em,tm.ver,tm.axa01,tm.axa02,g_bgjob  #NO.FUN-570145  #FUN-750058   #FUN-920076 #FUN-950048 mark
      #INPUT BY NAME tm.yy,tm.em,tm.ver,tm.axa01,tm.axa02,g_bgjob  #NO.FUN-570145  #FUN-750058   #FUN-920076  #FUN-950048 #FUN-A90026 mark
      INPUT BY NAME tm.axa01,tm.axa02,tm.yy,tm.axa06,tm.em,tm.q1,tm.h1,g_bgjob  #FUN-A90026
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
 
         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
              #SELECT axa01 FROM axa_file WHERE axa01=tm.axa01            #FUN-580063
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01   #FUN-580063
               IF STATUS THEN
#                 CALL cl_err(tm.axa01,'agl-117',0)     #No.FUN-660123
                  CALL cl_err3("sel","axa_file",tm.axa01,"","agl-117","","",0)   #No.FUN-660123
                  NEXT FIELD axa01
               END IF
            END IF
#FUN-A30122 ------------------mark start----------------------------------- 
#          str MOD-A20028 add
#           IF NOT cl_null(tm.axa02) THEN
#              SELECT COUNT(*) INTO l_cnt FROM axa_file 
#               WHERE axa01=tm.axa01 AND axa02=tm.axa02
#              IF l_cnt = 0  THEN 
#                 CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02 
#              ELSE
#                 SELECT DISTINCT axa03 INTO tm.axa03 FROM axa_file
#                  WHERE axa01=tm.axa01  
#                    AND axa02=tm.axa02  
#                 DISPLAY tm.axa03 TO axa03
#                 #上層公司編號在agli009中所設定工廠/DB
#                 SELECT axz03 INTO g_axz03 FROM axz_file
#                  WHERE axz01 = tm.axa02
##No.FUN-A30064  ---start---
#                 SELECT axa09 INTO l_axa09 FROM axa_file
#                  WHERE axa01 = tm.axa01
#                    AND axa02 = tm.axa02
#                    AND axa03 = tm.axa03
#                 IF l_axa09 = 'Y' THEN
#                    LET g_dbs_axz03 = s_dbstring(g_axz03)
#                 ELSE
#                    LET g_dbs_axz03 = s_dbstring(g_dbs)
#                 END IF 
##No.FUN-A30064 ---end ---
#                 LET g_plant_new = g_axz03      #營運中心
#                 CALL s_getdbs()
#                 LET g_dbs_axz03 = g_dbs_new    #上層公司所屬DB
#                 #上層公司所屬合併帳別
#                 #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#                 LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_axz03,'aaz_file'), #FUN-A50102
#                             " WHERE aaz00 = '0'"
#                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
#              CALL cl_parse_qry_sql(g_sql,g_axz03) RETURNING g_sql #FUN-A50102            
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
#         ON CHANGE axa02                                                        
          AFTER FIELD axa02   #FUN-A90026
            IF NOT cl_null(tm.axa02) THEN                                       
               SELECT count(*) INTO l_cnt FROM axa_file                         
               WHERE axa01=tm.axa01 AND axa02=tm.axa02                          
               IF l_cnt = 0  THEN                                               
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02          
               ELSE                                                             
                  SELECT DISTINCT axa03 INTO tm.axa03 FROM axa_file             
                  WHERE axa01=tm.axa01                                          
                  AND axa02=tm.axa02                                            
               END IF                                                           
               DISPLAY tm.axa03 TO axa03                                        
               CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_plant_axz03       
               CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                
            END IF 
            #--FUN-A90026 start-- 
            LET g_axa06 = '2'
            SELECT axa06 
              INTO g_axa06  #編制合併期別 1.月 2.季 3.半年 4.年
             FROM axa_file
            WHERE axa01 = tm.axa01     #族群編號
              AND axa04 = 'Y'   #最上層公司否
            LET tm.axa06 = g_axa06
            DISPLAY BY NAME tm.axa06

            CALL p001_set_no_entry()

            IF tm.axa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET tm.em = g_aaa05
            END IF
            IF tm.axa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.axa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.axa06 = '4' THEN
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
#        AFTER FIELD axa02  #公司編號
#           IF NOT cl_null(tm.axa02) THEN
#              SELECT count(*) INTO l_cnt FROM axa_file 
#               WHERE axa01=tm.axa01 AND axa02=tm.axa02
#                  IF l_cnt = 0  THEN 
#                     CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02 
#                  #--FUN-920076 start--
#                  ELSE
#                     SELECT DISTINCT axa03 INTO tm.axa03 FROM axa_file
#                      WHERE axa01=tm.axa01  
#                        AND axa02=tm.axa02  
#                     DISPLAY tm.axa03 TO axa03
#                     #上層公司編號在agli009中所設定工廠/DB
#                     SELECT axz03 INTO g_axz03 FROM axz_file
#                      WHERE axz01 = tm.axa02
#No.FUN-A30064 ---start----
#                     SELECT axa09 INTO l_axa09 FROM axa_file
#                      WHERE axa01 = tm.axa01
#                        AND axa02 = tm.axa02
#                        AND axa03 = tm.axa03
#                     IF l_axa09 = 'Y' THEN
#                        LET g_dbs_axz03 = s_dbstring(g_axz03)
#                     ELSE
#                        LET g_dbs_axz03 = s_dbstring(g_dbs)
#                     END IF  
#No.FUN-A30064 ---end---
#                     LET g_plant_new = g_axz03      #營運中心
#                     CALL s_getdbs()
#                     LET g_dbs_axz03 = g_dbs_new    #上層公司所屬DB
#                     
#                     #上層公司所屬合併帳別
#                     #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#                     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_axz03,'aaz_file'), #FUN-A50102
#                                 " WHERE aaz00 = '0'"
#                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
#                  CALL cl_parse_qry_sql(g_sql,g_axz03) RETURNING g_sql #FUN-A50102               
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
#         AFTER FIELD axa03  #帳別 
#            IF NOT cl_null(tm.axa03) THEN
#               SELECT count(*) INTO l_cnt FROM axa_file 
#                WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
#                   IF l_cnt = 0  THEN 
#                      CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa03 
#                   END IF
#            END IF
#--FUN-920076 mark-----
            
         #--MOD-A40192 start--   
         AFTER INPUT
            IF (NOT cl_null(tm.axa01) AND NOT cl_null(tm.axa02)) THEN  #TQC-AA0098
                CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03
                CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641
            END IF             #TQC-AA0098
         #--MOD-A40192 end----
         #--FUN-A90026 start--
            IF NOT cl_null(tm.axa06) THEN
               #CHI-B10030 add --start--
               IF tm.axa06 MATCHES '[234]' THEN      
                     CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                     CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
               END IF
               #CHI-B10030 add --end--
               #CHI-B10030 mark --start--
               #CASE
               #    WHEN tm.axa06 = '2'  #季 
               #         SELECT MAX(aznn01) INTO l_aznn01
               #           FROM aznn_file
               #          WHERE aznn00 = tm.axa03
               #            AND aznn02 = tm.yy
               #            AND aznn03 = tm.q1
               #         LET tm.em = MONTH(l_aznn01)
               #    WHEN tm.axa06 = '3'  #半年
               #         IF tm.h1 = '1' THEN  #上半年
               #             SELECT MAX(aznn01) INTO l_aznn01
               #               FROM aznn_file
               #              WHERE aznn00 = tm.axa03
               #                AND aznn02 = tm.yy
               #                AND aznn03 < 3
               #         ELSE                 #下半年
               #             SELECT MAX(aznn01) INTO l_aznn01
               #               FROM aznn_file
               #              WHERE aznn00 = tm.axa03
               #                AND aznn02 = tm.yy
               #                AND aznn03 >='3' #大於等於第三季
               #         END IF
               #         LET tm.em = MONTH(l_aznn01)
               #    WHEN tm.axa06 = '4'  #年
               #         SELECT MAX(aznn01) INTO l_aznn01
               #           FROM aznn_file
               #          WHERE aznn00 = tm.axa03
               #            AND aznn02 = tm.yy
               #         LET tm.em = MONTH(l_aznn01)
               #END CASE
               #CHI-B10030 mark --end--
            END IF
         #--FUN-A90026

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axa"
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
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
         CLOSE WINDOW aglp002_w
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
#   CLOSE WINDOW aglp002_w
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01= 'aglp002'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('aglp002','9031',1)   
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " ''",
                     #--FUN-A90026 mark--
                     #" '",tm.yy CLIPPED,"'",
                     #" '",tm.bm CLIPPED,"'",
                     #" '",tm.em CLIPPED,"'",
                     #" '",tm.axa01 CLIPPED,"'",
                     #" '",tm.axa02 CLIPPED,"'",
                     #" '",tm.axa03 CLIPPED,"'",
                     #" '",g_bgjob CLIPPED,"'",
                     #" '",tm.ver CLIPPED,"'"  #FUN-750058
                     #--FUN-A90026 mark---
                     #--FUN-A90026 start--
                     " '",tm.axa01 CLIPPED,"'",
                     " '",tm.axa02 CLIPPED,"'",
                     " '",tm.axa03 CLIPPED,"'",
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.axa06 CLIPPED,"'",
                     " '",tm.em CLIPPED,"'",
                     " '",tm.q1 CLIPPED,"'",
                     " '",tm.h1 CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
                     #--FUN-A90026 end---
                     
        CALL cl_cmdat('aglp002',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW aglp002_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM
  END IF
  EXIT WHILE
  #No.FUN-570145 ---end---
  ERROR ""
END WHILE
END FUNCTION
 
FUNCTION p002()
#DEFINE l_sql      LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(1000)
DEFINE l_sql       STRING,                       #MOD-CB0270 add
       l_axi03     LIKE axi_file.axi03,
       l_axi04     LIKE axi_file.axi04,
       l_axj03     LIKE axj_file.axj03,
       l_axj05     LIKE axj_file.axj05,          #FUN-910023 add
       l_axj06     LIKE axj_file.axj06,
       l_axj07     LIKE axj_file.axj07,
       l_axi21     LIKE axi_file.axi21,          #FUN-750058
       l_axz06     LIKE axz_file.axz06
#FUN-BA0111--
DEFINE l_aeii     RECORD
         aeii00   LIKE aeii_file.aeii00,
         aeii01   LIKE aeii_file.aeii00,
         aeii02   LIKE aeii_file.aeii00,
         aeii021  LIKE aeii_file.aeii021,
         aeii03   LIKE aeii_file.aeii03,
         aeii031  LIKE aeii_file.aeii031,
         aeii04   LIKE aeii_file.aeii04,
         aeii05   LIKE aeii_file.aeii05,
         aeii06   LIKE aeii_file.aeii06,
         aeii07   LIKE aeii_file.aeii07,
         aeii08   LIKE aeii_file.aeii08,
         aeii09   LIKE aeii_file.aeii09,
         aeii10   LIKE aeii_file.aeii10,
         aeii18   LIKE aeii_file.aeii18,
         aeii19   LIKE aeii_file.aeii19,
         aeii20   LIKE aeii_file.aeii20,
         aeii21   LIKE aeii_file.aeii21,
         aeii22   LIKE aeii_file.aeii22
                  END RECORD 
DEFINE l_aeii23   LIKE aeii_file.aeii23
DEFINE l_aeii24   LIKE aeii_file.aeii24  
#FUN-BA0111--
  #LET g_bookno=tm.axa03     #FUN-630063
  LET g_bookno=g_aaz641     #FUN-920076
  
  LET l_axz06=''
  SELECT axz06 INTO l_axz06 FROM axz_file WHERE axz01=tm.axa02
 
  ##axh_file :合併後會計科目各期餘額檔
  ##axkk_file:合併後科目異動碼沖帳餘額檔
  
##step 1 刪除資料
##delete axh_file
  DELETE FROM axh_file 
      WHERE axh00=g_bookno 
        AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
        AND axh04=tm.axa02            #No:9705
        #AND axh06=tm.yy AND axh07 BETWEEN tm.bm AND tm.em  #FUN-980067 mark
        AND axh06=tm.yy AND axh07 = tm.em    #FUN-980067 mod  
       #AND axh13=tm.ver  #FUN-750058        #FUN-770069 mark
        AND (axh13=tm.ver OR axh13=tm.em)    #FUN-770069
        AND axh12=l_axz06                    #FUN-930117
 #str FUN-910023 add
  DELETE FROM axkk_file 
      WHERE axkk00=g_bookno 
        AND axkk01=tm.axa01 AND axkk02=tm.axa02 AND axkk03=tm.axa03
        AND axkk04=tm.axa02
        #AND axkk08=tm.yy AND axkk09 BETWEEN tm.bm AND tm.em  #FUN-980067 mark
        AND axkk08=tm.yy AND axkk09 = tm.em      #FUN-980067
        AND (axkk15=tm.ver OR axkk15=tm.em)
        AND axkk14 = l_axz06    #FUN-930117
 #end FUN-910023 add
#FUN-9B0017   ---start
  DELETE FROM aeii_file
   WHERE aeii00=g_bookno
    #AND aeii01=tm.axa01 AND aeii02=tm.axa02 AND aeii03=tm.axa03  #FUN-A10015
     AND aeii01=tm.axa01 AND aeii02=tm.axa02 AND aeii021=tm.axa03 #FUN-A10015
    #AND aeii04=tm.axa02                                          #FUN-A10015
     AND aeii03=tm.axa02                                          #FUN-A10015
    #AND aeii08=tm.yy AND aeii09 = tm.em                          #MOD-C20100 mark
     AND aeii09=tm.yy AND aeii10 = tm.em     #FUN-AA0093
    #AND (aeii15=tm.ver OR aeii15=tm.em)                          #FUN-A10015
    #AND aeii14 = l_axz06                                         #FUN-A10015
     AND aeii18 = l_axz06                                         #FUN-A10015
#FUN-9B0017   ---end
  
##step 2 資料匯入
##axg_file->axh_file
  #FUN-AA0093 start--
  SELECT aaz113 INTO g_aaz113
    FROM aaz_file
   WHERE aaz00 = '0'
  #FUN-AA0093 end---
  INSERT INTO axh_file(axh00,axh01,axh02,axh03,axh04,axh041,
                       axh05,axh06,axh07,axh12,  #FUN-5A0020
                       axh08,axh09,axh10,axh11,axh13,axhlegal)  #FUN-750058 #FUN-980003 add legal
       SELECT axg00,axg01,axg02,axg03,axg02,axg03,axg05,axg06,axg07,
              axz06,   #FUN-5A0020
              SUM(axg08),SUM(axg09),SUM(axg10),SUM(axg11),axg17,axglegal  #FUN-750058 #FUN-980003 add axglegal
         FROM axg_file
             ,axz_file   #FUN-5A0020
        WHERE axg01=tm.axa01 AND axg02=tm.axa02 AND axg03=tm.axa03
          AND axg06=tm.yy                   #No.MOD-470574 (axh 改 axg)
#         AND axg07 between tm.bm and tm.em #No:9705 #No.MOD-470574(axh改axg)  #FUN-980067 mark
          AND axg07 = tm.em #FUN-980067 mod    
         #AND axg01=axz01   #MOD-740252 mark
          AND axg02=axz01   #MOD-740252
          AND axg00=g_aaz641  #FUN-5A0020   #FUN-920076
          #AND axg00=tm.axa03  #FUN-5A0020
          AND axg17=tm.ver  #FUN-750058
          AND axg12=axz06   #FUN-750058
          AND axg05 <> g_aaz113   #FUN-AA0093
        GROUP BY axg00,axg01,axg02,axg03,axg02,axg03,axg05,axg06,axg07
                ,axz06,axg17,axglegal   #FUN-750058 #FUN-980003 add axglegal
  IF SQLCA.sqlcode THEN 
     LET g_success= 'N'
#    CALL cl_err('ins axh_file(1)',SQLCA.sqlcode,0)   #No.FUN-660123
     CALL cl_err3("ins","axh_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","ins axh_file(1)",0)   #No.FUN-660123 
     RETURN                                                                                  #NO.FUN-710023       
  END IF
 #str FUN-910023 add
  INSERT INTO axkk_file(axkk00,axkk01,axkk02,axkk03,axkk04,axkk041,
                        axkk05,axkk06,axkk07,axkk08,axkk09,axkk10,
                        axkk11,axkk12,axkk13,axkk14,axkk15,axkklegal) #MOD-9C0421
       SELECT axk00,axk01,axk02,axk03,axk02,axk03,
              axk05,axk06,axk07,axk08,axk09,
              SUM(axk10),SUM(axk11),SUM(axk12),SUM(axk13),
              axz06,axk15,axklegal    #MOD-9C0421
         FROM axk_file,axz_file
        WHERE axk01=tm.axa01 AND axk02=tm.axa02 AND axk03=tm.axa03
          AND axk08=tm.yy
          #AND axk09 between tm.bm and tm.em  #FUN-980067 mark
           AND axk09 = tm.em   #FUN-980067
          AND axk02=axz01
          #AND axk00=tm.axa03
          AND axk00=g_aaz641   #FUN-920076
          AND axk15=tm.ver
          AND axk14=axz06
          AND axk05 <> g_aaz113   #FUN-AA0093
        GROUP BY axk00,axk01,axk02,axk03,axk02,axk03,
                 axk05,axk06,axk07,axk08,axk09,axz06,axk15,axklegal  #MOD-9C0421
  IF SQLCA.sqlcode THEN
     LET g_success= 'N'
     CALL cl_err3("ins","axkk_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","ins axkk_file(1)",0)
     RETURN
  END IF
 #end FUN-910023 add
#FUN-A10015 --Begin
  INSERT INTO aeii_file(aeii00,aeii01,aeii02,aeii021,aeii03,aeii031,aeii04,
                        aeii05,aeii06,aeii07,aeii08,aeii09,aeii10,aeii11,
                        aeii12,aeii13,aeii14,aeii15,aeii16,aeii17,aeii18,aeiilegal
                        ,aeii19,aeii20,aeii21,aeii22,aeii23,aeii24)         #FUN-BA0111 add 
       SELECT aei00,aei01,aei02,aei021,aei02,aei021,aei04,   #MOD-AC0232 
       #SELECT aei00,aei01,aei02,aei021,aei03,aei031,aei04,
              aei05,aei06,aei07,aei08,aei09,aei10,
              SUM(aei11),SUM(aei12),SUM(aei13),SUM(aei14),
             #aei15,aei16,aei17,axz06,aeilegal                #TQC-B20178 mark
             #aei15,aei16,'0',axz06,aeilegal                  #TQC-B20178 mod   #MOD-B80141 mark
              aei15,'0','0',axz06,aeilegal,                   #MOD-B80141 add
             #aei19,aei20,aei21,aei22,' ',' '                 #FUN-BA0111 add #MOD-CB0270 mark
              aei19,aei20,aei21,aei22,aei23,aei24             #MOD-CB0270 add
         FROM aei_file,axz_file
        WHERE aei01=tm.axa01 AND aei02=tm.axa02 AND aei021=tm.axa03
          AND aei09=tm.yy
          AND aei10 = tm.em
          AND aei02=axz01
          AND aei00=g_aaz641
          AND aei15=tm.ver
          AND aei18=axz06
        GROUP BY aei00,aei01,aei02,aei021,aei02,aei021,aei04,    #MOD-AC0232
        #GROUP BY aei00,aei01,aei02,aei021,aei03,aei031,aei04,
                #aei05,aei06,aei07,aei08,aei09,aei10,aei15,aei16,aei17,axz06,aeilegal   #TQC-B20178 mark
                #aei05,aei06,aei07,aei08,aei09,aei10,aei15,aei16,axz06,aeilegal         #TQC-B20178 mod #MOD-B80141 mark
                 aei05,aei06,aei07,aei08,aei09,aei10,aei15,axz06,aeilegal,              #MOD-B80141 add
                #aei19,aei20,aei21,aei22                                                #FUN-BA0111 add #MOD-CB0270 mark
                 aei19,aei20,aei21,aei22,aei23,aei24                                    #MOD-CB0270 add
  IF SQLCA.sqlcode THEN
     LET g_success= 'N'
     CALL cl_err3("ins","aeii_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","ins aeii_file(1)",0)
     RETURN
  END IF
  #FUN-BA0111--
   LET l_sql = " SELECT aeii00,aeii01,aeii02,aeii021,aeii03"
              ,"       ,aeii031,aeii04,aeii05,aeii06,aeii07"
              ,"       ,aeii08,aeii09,aeii10,aeii18,aeii19"
              ,"       ,aeii20,aeii21,aeii22" 
              ,"  FROM aeii_file"
              ," WHERE aeii01 = '",tm.axa01,"' AND aeii02 = '",tm.axa02,"' AND aeii021 = '",tm.axa03,"'"
              ,"   AND aeii09 = ",tm.yy," AND aeii10=",tm.em," AND aeii00='",g_aaz641,"' AND aeii15='",tm.ver,"'"
             #,"   AND aeii23 = ' ' AND aeii24 = ' '"                                                                  #MOD-CB0270 mark
   PREPARE p002_aeii_p FROM l_sql
   DECLARE p002_aeii_c CURSOR FOR p002_aeii_p 
   FOREACH p002_aeii_c INTO l_aeii.*
      CALL p002_get_aeii23(
                        l_aeii.aeii00,l_aeii.aeii01,l_aeii.aeii02,l_aeii.aeii021,l_aeii.aeii03  
                       ,l_aeii.aeii031,l_aeii.aeii04,l_aeii.aeii05,l_aeii.aeii06,l_aeii.aeii07  
                       ,l_aeii.aeii08,l_aeii.aeii09,l_aeii.aeii10,l_aeii.aeii18,l_aeii.aeii19  
                       ,l_aeii.aeii20,l_aeii.aeii21,l_aeii.aeii22)
                 RETURNING l_aeii23,l_aeii24
      UPDATE aeii_file set aeii23 = l_aeii23, aeii24 = l_aeii24
       WHERE aeii00  = l_aeii.aeii00  AND aeii01 = l_aeii.aeii01 AND aeii02  = l_aeii.aeii02
         AND aeii021 = l_aeii.aeii021 AND aeii03 = l_aeii.aeii03 AND aeii031 = l_aeii.aeii031
         AND aeii04  = l_aeii.aeii04  AND aeii05 = l_aeii.aeii05 AND aeii06  = l_aeii.aeii06
         AND aeii07  = l_aeii.aeii07  AND aeii08 = l_aeii.aeii08 AND aeii09  = l_aeii.aeii09
         AND aeii10  = l_aeii.aeii10  AND aeii18 = l_aeii.aeii18 AND aeii19  = l_aeii.aeii19
         AND aeii20  = l_aeii.aeii20  AND aeii21 = l_aeii.aeii21 AND aeii22  = l_aeii.aeii22
   END FOREACH
  #FUN-BA0111--
#FUN-A10015 --End
 
##step 3 調整分錄資料更新合併資料
##ref.dbo.axi_file and axj_file update axh_file
 
  LET l_sql=" SELECT axi03,axi04,axj03,axj06,SUM(axj07),axi21 ", #FUN-750058
            "  FROM axi_file,axj_file ",
            " WHERE axi01=axj01 AND axi00= '",g_bookno,"' ",
            "  AND  axi00=axj00                           ",
            "  AND axi03=",tm.yy,
            #"  AND axi04 BETWEEN ",tm.bm," AND ",tm.em, #FUN-980067 mark
             "  AND axi04 = ",tm.em,   #FUN-980067 add     
            "  AND axi05='",tm.axa01,"' AND axi06='",tm.axa02,"'",
            "  AND axi07='",tm.axa03,"'",
            "  AND axiconf='Y' ",
            "  AND axi21='",tm.ver,"'",  #FUN-750058
           #"  AND axi08 <> '1'",        #TQC-BA0129 Mark #FUN-A90026 
            "  AND axi08 IN ('2','3')",  #TQC-BA0129 
            "  AND axj03 <> '",g_aaz113,"'",  #FUN-AA0093
            " GROUP BY axi03,axi04,axj03,axj06,axi21 "  #FUN-750058
            
  PREPARE p002_axi_p FROM l_sql
  IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
     CALL cl_batch_bg_javamail('N')        #FUN-570145  
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
     EXIT PROGRAM 
  END IF
  DECLARE p002_axi_c CURSOR FOR p002_axi_p
  CALL s_showmsg_init()                            #NO.FUN-710023
  FOREACH p002_axi_c INTO l_axi03,l_axi04,l_axj03,l_axj06,l_axj07,l_axi21  #FUN-750058
#NO.FUN-710023--BEGIN                                                           
     IF g_success='N' THEN                                                    
       LET g_totsuccess='N'                                                   
       LET g_success='Y'                                                      
     END IF  
#NO.FUN-710023--END
     IF SQLCA.sqlcode THEN 
#       CALL cl_err('p002_axi_c',SQLCA.sqlcode,0)    #NO.FUN-710023
        LET g_showmsg=g_bookno,"/",tm.yy,"/",tm.axa01,"/",tm.axa02,"/",tm.axa03,"/","Y"
        CALL s_errmsg('axi00,axi03,axi05,axi06,axi07,axiconf',g_showmsg,'p002_axi_c',SQLCA.sqlcode,0) 
        LET g_success ='N' #FUN-8A0086
        EXIT FOREACH 
     END IF 
     CASE 
        WHEN l_axj06='1'
           UPDATE axh_file SET axh08=axh08+l_axj07 
            WHERE axh00=g_bookno AND axh01=tm.axa01 
              AND axh02=tm.axa02 AND axh03=tm.axa03
              AND axh04=tm.axa02 AND axh041=tm.axa03 
              AND axh06=l_axi03  AND axh07=l_axi04
              AND axh05=l_axj03 
              AND axh12=l_axz06  #FUN-750058
              AND axh13=l_axi21  #FUN-750058
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
              INSERT INTO axh_file(axh00,axh01,axh02,axh03,axh04,axh041,  #No.MOD-470041
                                   axh05,axh06,axh07,axh08,axh09,axh10,
                                   axh11,axh12,axh13,axhlegal)   #FUN-750058 #FUN-980003 add axhlegal
                  VALUES(g_bookno,tm.axa01,tm.axa02,tm.axa03,tm.axa02,
                         tm.axa03,l_axj03,l_axi03,l_axi04,
                         l_axj07,0,1,0,l_axz06,l_axi21,g_legal) #FUN-750058 #FUN-980003 add legal
              IF SQLCA.sqlcode THEN 
#                CALL cl_err('ins axh_file(2)',SQLCA.sqlcode,0)   #No.FUN-660123
#                CALL cl_err3("ins","axh_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","ins axh_file(2)",0)   #No.FUN-660123  #NO.FUN-710023
                 LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03 
                 CALL s_errmsg('axh01,axh02,axh03',g_showmsg,'ins axh_file(2)',SQLCA.sqlcode,1)          #NO.FUN-710023
                 LET g_success = 'N'    
#                RETURN                                                                                  #NO.FUN-710023 
                 CONTINUE FOREACH                                                                        #NO.FUN-710023 
              END IF
           END IF
        WHEN l_axj06='2'
           UPDATE axh_file SET axh09=axh09+l_axj07 
            WHERE axh00=g_bookno and axh01=tm.axa01 
              and axh02=tm.axa02 and axh03=tm.axa03
              and axh04=tm.axa02 and axh041=tm.axa03 
              and axh06=l_axi03 and axh07=l_axi04
              and axh05=l_axj03
              AND axh12=l_axz06  #FUN-750058
              AND axh13=l_axi21  #FUN-750058
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
              INSERT INTO axh_file(axh00,axh01,axh02,axh03,axh04,axh041,  #No.MOD-470041
                                   axh05,axh06,axh07,axh08,axh09,axh10,
                                   axh11,axh12,axh13,axhlegal)  #FUN-750058 #FUN-980003 add axhlegal
                  VALUES(g_bookno,tm.axa01,tm.axa02,tm.axa03,tm.axa02,
                         tm.axa03,l_axj03,l_axi03,l_axi04,
                         0,l_axj07,0,1,l_axz06,l_axi21,g_legal)  #FUN-980003 add g_legal
              IF SQLCA.sqlcode THEN 
#                CALL cl_err('ins axh_file(3)',SQLCA.sqlcode,0)   #No.FUN-660123
#                CALL cl_err3("ins","axh_file",tm.axa01,tm.axa02,SQLCA.sqlcode,"","ins axh_file(3)",0)   #No.FUN-660123 #NO.FUN-710023
                 LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03 
                 CALL s_errmsg('axh01,axh02,axh03',g_showmsg,'ins axh_file(2)',SQLCA.sqlcode,1)          #NO.FUN-710023
                 LET g_success = 'N' 
#                RETURN                                                                                  #NO.FUN-710023 
                 CONTINUE FOREACH                                                                        #NO.FUN-710023 
              END IF
           END IF
        OTHERWISE EXIT CASE
     END CASE
  END FOREACH
   
 #str FUN-910023 add
  LET l_sql=" SELECT axi03,axi04,axj03,axj05,axj06,SUM(axj07),axi21 ",
            "  FROM axi_file,axj_file ",
            " WHERE axi01=axj01 AND axi00= '",g_bookno,"' ",
            "  AND  axi00=axj00                           ",
            "  AND axi03=",tm.yy,
            #"  AND axi04 BETWEEN ",tm.bm," AND ",tm.em,  #FUN-980067 mark
             "  AND axi04 = ",tm.em,          #FUN-980067 add
            "  AND axi05='",tm.axa01,"' AND axi06='",tm.axa02,"'",
            "  AND axi07='",tm.axa03,"'",
            "  AND axiconf='Y' ",
            "  AND axi21='",tm.ver,"'",
            "  AND (axj05 IS NOT NULL OR axj05 <> ' ')",  
           #"  AND axi08 <> '1'",        #TQC-BA0129 Mark #FUN-A90026 
            "  AND axi08 IN ('2','3') ", #TQC-BA0129 
            "  AND axj03 <> '",g_aaz113,"'",   #FUN-AA0093
            " GROUP BY axi03,axi04,axj03,axj05,axj06,axi21 "
            
  PREPARE p002_axi_p1 FROM l_sql
  IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
     CALL cl_batch_bg_javamail('N')
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM 
  END IF
  DECLARE p002_axi_c1 CURSOR FOR p002_axi_p1
  CALL s_showmsg_init()
  FOREACH p002_axi_c1 INTO l_axi03,l_axi04,l_axj03,l_axj05,
                           l_axj06,l_axj07,l_axi21
     IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
     END IF  
     IF SQLCA.sqlcode THEN 
        LET g_showmsg=g_bookno,"/",tm.yy,"/",tm.axa01,"/",tm.axa02,"/",tm.axa03,"/","Y"
        CALL s_errmsg('axi00,axi03,axi05,axi06,axi07,axiconf',g_showmsg,'p002_axi_c1',SQLCA.sqlcode,0) 
        LET g_success ='N'
        EXIT FOREACH 
     END IF 
     CASE 
        WHEN l_axj06='1'
           UPDATE axkk_file SET axkk10=axkk10+l_axj07 
            WHERE axkk00=g_bookno AND axkk01 =tm.axa01 
              AND axkk02=tm.axa02 AND axkk03 =tm.axa03
              AND axkk04=tm.axa02 AND axkk041=tm.axa03 
              AND axkk08=l_axi03  AND axkk09 =l_axi04
              AND axkk05=l_axj03 
              AND axkk14=l_axz06
              AND axkk15=l_axi21
              AND axkk07=l_axj05                        #MOD-A30100
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
              INSERT INTO axkk_file(axkk00,axkk01,axkk02,axkk03,axkk04,axkk041,
                                    axkk05,axkk06,axkk07,axkk08,axkk09,axkk10,
                                    axkk11,axkk12,axkk13,axkk14,axkk15,axkklegal) #MOD-9C0421
              VALUES(g_bookno,tm.axa01,tm.axa02,tm.axa03,tm.axa02,tm.axa03,
                     l_axj03,'99',l_axj05,l_axi03,l_axi04,
                     l_axj07,0,1,0,l_axz06,l_axi21,g_legal)  #MOD-9C0421
              IF SQLCA.sqlcode THEN 
                 LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03 
                 CALL s_errmsg('axkk01,axkk02,axkk03',g_showmsg,'ins axkk_file(2)',SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 CONTINUE FOREACH
              END IF
           END IF
        WHEN l_axj06='2'
           UPDATE axkk_file SET axkk11=axkk11+l_axj07 
            WHERE axkk00=g_bookno AND axkk01 =tm.axa01 
              AND axkk02=tm.axa02 AND axkk03 =tm.axa03
              AND axkk04=tm.axa02 AND axkk041=tm.axa03 
              AND axkk08=l_axi03  AND axkk09 =l_axi04
              AND axkk05=l_axj03 
              AND axkk14=l_axz06
              AND axkk15=l_axi21
              AND axkk07=l_axj05                        #MOD-A30100
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
              INSERT INTO axkk_file(axkk00,axkk01,axkk02,axkk03,axkk04,axkk041,
                                    axkk05,axkk06,axkk07,axkk08,axkk09,axkk10,
                                    axkk11,axkk12,axkk13,axkk14,axkk15,axkklegal) #MOD-9C0421
              VALUES(g_bookno,tm.axa01,tm.axa02,tm.axa03,tm.axa02,tm.axa03,
                     l_axj03,'99',l_axj05,l_axi03,l_axi04,
                     0,l_axj07,0,1,l_axz06,l_axi21,g_legal)  #MOD-9C0421
              IF SQLCA.sqlcode THEN 
                 LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03 
                 CALL s_errmsg('axkk01,axkk02,axkk03',g_showmsg,'ins axkk_file(2)',SQLCA.sqlcode,1)
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
#除了會寫入一筆axh13(版本)為00的資料之外，
#還要再寫入一筆axh13(版本)為3(以截止期別為版本)的資料
FUNCTION p002_ins_ver()   
 
  DROP TABLE x
 
  SELECT * FROM axh_file
   WHERE axh00=tm.axa03
     AND axh01=tm.axa01 
     AND axh02=tm.axa02 
     AND axh03=tm.axa03
     AND axh06=tm.yy
     AND axh07 BETWEEN tm.bm AND tm.em
     AND axh13=tm.ver
    INTO TEMP x
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","x", tm.axa01,tm.axa02,SQLCA.sqlcode,"","",1)
     RETURN
  END IF
 
  UPDATE x SET axh13 = tm.em
 
  INSERT INTO axh_file SELECT * FROM x
  IF SQLCA.sqlcode THEN
     LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03 
     CALL s_errmsg('axh01,axh02,axh03',g_showmsg,'ins axh_file(3)',SQLCA.sqlcode,1)
     LET g_success = 'N'    
  END IF
 
 #str FUN-910023 add
  DROP TABLE y
  SELECT * FROM axkk_file
   #WHERE axkk00=tm.axa03
   WHERE axkk00=g_aaz641  #FUN-920076 mod
     AND axkk01=tm.axa01 
     AND axkk02=tm.axa02 
     AND axkk03=tm.axa03
     AND axkk08=tm.yy
     AND axkk09 BETWEEN tm.bm AND tm.em
     AND axkk15=tm.ver
    INTO TEMP y
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","y", tm.axa01,tm.axa02,SQLCA.sqlcode,"","",1)
     RETURN
  END IF
  UPDATE y SET axkk15 = tm.em
  INSERT INTO axkk_file SELECT * FROM y
  IF SQLCA.sqlcode THEN
     LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.axa03 
     CALL s_errmsg('axkk01,axkk02,axkk03',g_showmsg,'ins axkk_file(3)',SQLCA.sqlcode,1)
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

      CALL cl_set_comp_entry("axa06",FALSE) 

      IF tm.axa06 ="1" THEN  #月
         CALL cl_set_comp_entry("q1,h1",FALSE) 
      END IF
      IF tm.axa06 ="2" THEN  #季
         CALL cl_set_comp_entry("em,h1",FALSE) 
      END IF
      IF tm.axa06 ="3" THEN  #半年
         CALL cl_set_comp_entry("em,q1",FALSE) 
      END IF
      IF tm.axa06 ="4" THEN  #年
         CALL cl_set_comp_entry("q1,em,h1",FALSE) 
      END IF
END FUNCTION
#--FUN-A90026 end------------------
#FUN-BA0111--
FUNCTION p002_get_aeii23(l_aeii00,l_aeii01,l_aeii02,l_aeii021,l_aeii03,l_aeii031,l_aeii04,l_aeii05,l_aeii06,l_aeii07,l_aeii08,l_aeii09,l_aeii10,l_aeii18,l_aeii19,l_aeii20,l_aeii21,l_aeii22)
DEFINE l_aeii00   LIKE aeii_file.aeii00
DEFINE l_aeii01   LIKE aeii_file.aeii01
DEFINE l_aeii02   LIKE aeii_file.aeii02
DEFINE l_aeii021  LIKE aeii_file.aeii021
DEFINE l_aeii03   LIKE aeii_file.aeii03
DEFINE l_aeii031  LIKE aeii_file.aeii031
DEFINE l_aeii04   LIKE aeii_file.aeii04
DEFINE l_aeii05   LIKE aeii_file.aeii05
DEFINE l_aeii06   LIKE aeii_file.aeii06
DEFINE l_aeii07   LIKE aeii_file.aeii07
DEFINE l_aeii08   LIKE aeii_file.aeii08
DEFINE l_aeii09   LIKE aeii_file.aeii09
DEFINE l_aeii10   LIKE aeii_file.aeii10
DEFINE l_aeii18   LIKE aeii_file.aeii18
DEFINE l_aeii19   LIKE aeii_file.aeii19
DEFINE l_aeii20   LIKE aeii_file.aeii20
DEFINE l_aeii21   LIKE aeii_file.aeii21
DEFINE l_aeii22   LIKE aeii_file.aeii22
DEFINE l_aeii23   LIKE aeii_file.aeii23
DEFINE l_aeii24   LIKE aeii_file.aeii24
DEFINE l_str     STRING

   LET l_str    = l_aeii00
   LET l_aeii23 = l_str.trim()
   LET l_str    = l_aeii01 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii02 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii021
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii03 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii031
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii04 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii05 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii06 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii07 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii08 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii09 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii10 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()
   LET l_str    = l_aeii18 
   LET l_aeii23 = l_aeii23 CLIPPED,l_str.trim()

   LET l_str    = l_aeii19 
   LET l_aeii24 = l_str.trim()
   LET l_str    = l_aeii20 
   LET l_aeii24 = l_aeii24 CLIPPED,l_str.trim()
   LET l_str    = l_aeii21 
   LET l_aeii24 = l_aeii24 CLIPPED,l_str.trim()
   LET l_str    = l_aeii22 
   LET l_aeii24 = l_aeii24 CLIPPED,l_str.trim()
   IF cl_null(l_aeii23) THEN LET l_aeii23 = ' ' END IF
   IF cl_null(l_aeii24) THEN LET l_aeii24 = ' ' END IF
   RETURN l_aeii23,l_aeii24
END FUNCTION
#FUN-BA0111--
