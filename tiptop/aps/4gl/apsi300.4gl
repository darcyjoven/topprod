# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apsi300.4gl
# Descriptions...: 工作模式資料維護作業
# Date & Author..: 02/03/14 By Mandy
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-720043 07/03/21 By Mandy APS相關調整
# Modify.........: NO.FUN-850114 07/12/25 BY yiting apsi104->apsi300
# Modify.........: NO.FUN-870099 08/07/21 By Duke add start,ending time to time format
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50004 11/05/26 By Abby APS GP5.25 追版
# Modify.........: No.FUN-B80181 11/08/31 By Abby apsi300單身刪除或工作模式編號改變時,需check 工作模式編號[vma01]
#                                                 (1)在apsi301 的工作模式[vmb03]未被使用,若有被使用則show提示且無法刪除或改變
#                                                 (2)在apsi302 的星期一~星期日工作模式編號[vmc02]~[vmc08]未被使用,若有被使用則show提示且無法刪除或改變
# Modify.........: No.FUN-D10140 13/01/31 By Mandy 開始時間及結束時間,若有輸入為30分時,後續再重查時,顯示異常(ex:00:30:01)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vma           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        vma01            LIKE vma_file.vma01, 
        vma02_1          LIKE type_file.chr10, #FUN-870099  開始時間設定時間格式
        vma02            LIKE type_file.num10,#FUN-720043 限制不能輸入小數數位
        vma03_1          LIKE type_file.chr10,#FUN-870099   開始時間設定時間格式
        vma03            LIKE type_file.num10,#FUN-720043
        vma04            LIKE vma_file.vma04,
        vma05            LIKE vma_file.vma05,
        vma06            LIKE vma_file.vma06,
        vma02_1a         LIKE type_file.chr2,  #FUN-870099
        vma02_1b         LIKE type_file.chr2,  #FUN-870099
        vma02_1c         LIKE type_file.chr2,  #FUN-870099
        vma03_1a         LIKE type_file.chr2,  #FUN-870099
        vma03_1b         LIKE type_file.chr2,  #FUN-870099
        vma03_1c         LIKE type_file.chr2   #FUN-870099
                         END RECORD,
    g_vma_t         RECORD                 #程式變數 (舊值)
        vma01            LIKE vma_file.vma01,
        vma02_1          LIKE type_file.chr10,#FUN-870099
        vma02            LIKE type_file.num10,#FUN-720043
        vma03_1          LIKE type_file.chr10,#FUN-870099
        vma03            LIKE type_file.num10,#FUN-720043
        vma04            LIKE vma_file.vma04,
        vma05            LIKE vma_file.vma05,
        vma06            LIKE vma_file.vma06,
        vma02_1a         LIKE type_file.chr2,  #FUN-870099
        vma02_1b         LIKE type_file.chr2,  #FUN-870099
        vma02_1c         LIKE type_file.chr2,  #FUN-870099
        vma03_1a         LIKE type_file.chr2,  #FUN-870099
        vma03_1b         LIKE type_file.chr2,  #FUN-870099
        vma03_1c         LIKE type_file.chr2   #FUN-870099
 
                         END RECORD,
    g_wc2,g_sql          string,  #No.FUN-580092 HCN
    g_rec_b              LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac                 LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done LIKE type_file.num5      #No.FUN-570110  #No.FUN-690010 SMALLINT
DEFINE   g_cnt               LIKE type_file.num10     #No.FUN-690010 INTEGER

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW i300_w WITH FORM "aps/42f/apsi300"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i300_b_fill(g_wc2)
    CALL i300_menu()
    CLOSE WINDOW i300_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i300_menu()
 
   #FUN-870099  set  visible
   CALL cl_set_comp_visible("vma02,vma03,vma02_1a,vma02_1b,vma02_1c,vma03_1a,vma03_1b,vma03_1c",FALSE)
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i300_q()
   CALL i300_b_askkey()
END FUNCTION
 
FUNCTION i300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用         #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否         #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態           #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1    #No.FUN-690010 VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    #FUN-870099   將秒數轉換成時間格式
    LET g_forupd_sql = " SELECT vma01,substr(vma02_1a || vma02_1b || vma02_1c,1,8) vma02_1, vma02, ",  #FUN-B50004 mod
                                    " substr(vma03_1a || vma03_1b || vma03_1c,1,8) vma03_1, vma03, ",  #FUN-B50004 mod
                              " vma04,vma05,vma06 ",
                       " FROM ",            
                       "  ( ",
                       "    select  vma01, ",
                       "            case when vma02_1a=0 then '00:'   ",
                       "                 when vma02_1a<10 then  '0'||vma02_1a||':' ",   
                       "                 else vma02_1a||':'    end vma02_1a,  ",
                       "            case when vma02_1b=0 then '00:'   ",
                       "                 when vma02_1b<10 then  '0'||vma02_1b||':'  ", 
                       "                 else vma02_1b||':'    end vma02_1b, ",
                       "            case when vma02_1c=0 then '00:'  ",
                       "                 when vma02_1c<10 then  '0'||vma02_1c||':'  ",  
                       "                 else vma02_1c||':'    end vma02_1c, ",
                       "            case when vma03_1a=0 then '00:'  ",
                       "                 when vma03_1a<10 then  '0'||vma03_1a||':' ",   
                       "                 else vma03_1a||':'    end vma03_1a, ",
                       "            case when vma03_1b=0 then '00:'  ",
                       "                 when vma03_1b<10 then  '0'||vma03_1b||':'   ",
                       "                 else vma03_1b||':'    end vma03_1b, ",
                       "            case when vma03_1c=0 then '00:'  ",
                       "                 when vma03_1c<10 then  '0'||vma03_1c||':'   ",
                       "                 else vma03_1c||':'    end vma03_1c,",
                       "            vma02,vma03,vma04,vma05,vma06     ",
                       "     FROM  ",
                       "       (SELECT vma01,'',vma02,'',vma03,vma04,vma05,vma06,   ",     
                      #"               CAST(vma02/3600 AS INT) vma02_1a,CAST((vma02-(CAST(vma02/3600 AS INT)*3600))/60 AS INT) vma02_1b,MOD(vma02,60) vma02_1c, ",  #FUN-B50004 mod #FUN-D10140 mark
                       "              FLOOR(vma02/3600)        vma02_1a,FLOOR((vma02-(FLOOR(vma02/3600)*3600))/60)             vma02_1b,MOD(vma02,60) vma02_1c, ",                  #FUN-D10140 add
                      #"               CAST(vma03/3600 AS INT) vma03_1a,CAST((vma03-(CAST(vma03/3600 AS INT)*3600))/60 AS INT) vma03_1b,MOD(vma03,60) vma03_1c  ",  #FUN-B50004 mod #FUN-D10140 mark
                       "              FLOOR(vma03/3600)        vma03_1a,FLOOR((vma03-(FLOOR(vma03/3600)*3600))/60)             vma03_1b,MOD(vma03,60) vma03_1c  ",                  #FUN-D10140 add
                       "               FROM vma_file   WHERE vma01 =? AND vma02 = ?  ",
                       "       )  ",
                       "  )       ",
                       " FOR UPDATE " #FUN-B50004 add
    
 
    #LET g_forupd_sql = "SELECT vma01,'',vma02,'',vma03,vma04,vma05,vma06, ",
    #              "       CAST(vma02/3600 AS INT) vma02_1a,CAST((vma02-(CAST(vma02/3600 AS INT)*3600))/60 AS INT) vma02_1b,vma02%60 vma02_1c, ",
    #              "       CAST(vma03/3600 AS INT) vma03_1a,CAST((vma03-(CAST(vma03/3600 AS INT)*3600))/60 AS INT) vma03_1b,vma03%60 vma03_1c  ",
    #              "       FROM vma_file ",
    #                   " WHERE vma01 = ? AND vma02 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_vma WITHOUT DEFAULTS FROM s_vma.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET g_vma_t.* = g_vma[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
#No.FUN-570110--begin
               LET g_before_input_done = FALSE
               CALL i300_set_entry_b(p_cmd)
               CALL i300_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110--end
               LET g_vma_t.* = g_vma[l_ac].*  #BACKUP
               BEGIN WORK
               OPEN i300_bcl USING g_vma_t.vma01,g_vma_t.vma02
               IF STATUS THEN
                  CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i300_bcl INTO g_vma[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD vma01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin
            LET g_before_input_done = FALSE
            CALL i300_set_entry_b(p_cmd)
            CALL i300_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110--end          #No.FUN-570110--begin
            LET g_before_input_done = FALSE
            CALL i300_set_entry_b(p_cmd)
            CALL i300_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110--end
            INITIALIZE g_vma[l_ac].* TO NULL
            #FUN-720043-------add----------str------
            LET g_vma[l_ac].vma02 = 0
            LET g_vma[l_ac].vma03 = 0
            LET g_vma[l_ac].vma04 = 0       
            #FUN-720043-------add----------end------
            LET g_vma_t.* = g_vma[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD vma01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO vma_file(vma01,vma02,vma03,vma04,vma05,vma06) #No.MOD-470041
             VALUES(g_vma[l_ac].vma01,
                    g_vma[l_ac].vma02,
                    g_vma[l_ac].vma03,
                    g_vma[l_ac].vma04,
                    g_vma[l_ac].vma05,
                    g_vma[l_ac].vma06)
         IF SQLCA.sqlcode THEN
#             CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
             CALL cl_err3("ins","vma_file",g_vma[l_ac].vma01,g_vma[l_ac].vma02,SQLCA.sqlcode,"","",1)  # Fun - 660095
             LET g_vma[l_ac].* = g_vma_t.*
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

        #FUN-B80181 add str---
         AFTER FIELD vma01
            IF NOT cl_null(g_vma[l_ac].vma01) AND (g_vma[l_ac].vma01 != g_vma_t.vma01) THEN
               SELECT count(*) INTO l_n FROM vmb_file
                WHERE vmb03 = g_vma_t.vma01
               IF l_n > 0 THEN
                   CALL cl_err('','aps-804',0)
                   LET g_vma[l_ac].vma01 = g_vma_t.vma01
                   NEXT FIELD vma01
               END IF
                  SELECT count(*) INTO l_n FROM vmc_file
                   WHERE vmc02 = g_vma_t.vma01
                      OR vmc03 = g_vma_t.vma01
                      OR vmc04 = g_vma_t.vma01
                      OR vmc05 = g_vma_t.vma01
                      OR vmc06 = g_vma_t.vma01
                      OR vmc07 = g_vma_t.vma01
                      OR vmc08 = g_vma_t.vma01
                  IF l_n > 0 THEN
                     CALL cl_err('','aps-805',0)
                     LET g_vma[l_ac].vma01 = g_vma_t.vma01
                     NEXT FIELD vma01
                  END IF
            END IF
        #FUN-B80181 add end--- 

        #FUN-870099
         AFTER FIELD vma02_1
             IF  (cl_null(g_vma[l_ac].vma02_1)) or
                 (g_vma[l_ac].vma02_1[3,3]<>':') or
                 (g_vma[l_ac].vma02_1[6,6]<>':') or
                 (cl_null(g_vma[l_ac].vma02_1[8,8])) or
                 (g_vma[l_ac].vma02_1[1,2]<'00' or g_vma[l_ac].vma02_1[1,2]>'24') or
                 (g_vma[l_ac].vma02_1[4,5]<'00' or g_vma[l_ac].vma02_1[4,5]>'60') or
                 (g_vma[l_ac].vma02_1[7,8]<'00' or g_vma[l_ac].vma02_1[7,8]>'60') THEN
                 CALL cl_err('','aem-006',1)
                 NEXT  FIELD vma02_1
             END IF
             LET g_vma[l_ac].vma02 = g_vma[l_ac].vma02_1[1,2]*60*60 +
                         g_vma[l_ac].vma02_1[4,5]*60 +
                         g_vma[l_ac].vma02_1[7,8]
             DISPLAY BY NAME g_vma[l_ac].vma02
             IF not cl_null(g_vma[l_ac].vma03_1) THEN
                IF g_vma[l_ac].vma02>g_vma[l_ac].vma03 THEN
                   CALL cl_err('','mfg9234',1)
                   LET g_vma[l_ac].vma02_1 = g_vma_t.vma02_1
                   LET g_vma[l_ac].vma02   = g_vma_t.vma02
                   NEXT FIELD vma02_1
                END IF
             END IF
             IF NOT cl_null(g_vma[l_ac].vma02_1) THEN
                IF (g_vma_t.vma01 != g_vma[l_ac].vma01 OR
                    g_vma_t.vma02 != g_vma[l_ac].vma02 OR
                    p_cmd='a') THEN
                   SELECT count(*) INTO l_n FROM vma_file
                    WHERE vma01 = g_vma[l_ac].vma01
                      AND vma02 = g_vma[l_ac].vma02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_vma[l_ac].vma01 = g_vma_t.vma01
                       LET g_vma[l_ac].vma02 = g_vma_t.vma02
                       NEXT FIELD vma02
                   END IF
                END IF
             END IF
 
 
         AFTER FIELD vma03_1
             IF  (not cl_null(g_vma[l_ac].vma03_1)) AND 
                 ((g_vma[l_ac].vma03_1[3,3]<>':') or
                 (g_vma[l_ac].vma03_1[6,6]<>':') or
                 (cl_null(g_vma[l_ac].vma03_1[8,8])) or
                 (g_vma[l_ac].vma03_1[1,2]<'00' or g_vma[l_ac].vma03_1[1,2]>'60') or
                 (g_vma[l_ac].vma03_1[4,5]<'00' or g_vma[l_ac].vma03_1[4,5]>'60') or
                 (g_vma[l_ac].vma03_1[7,8]<'00' or g_vma[l_ac].vma03_1[7,8]>'60')) THEN
                 CALL cl_err('','aem-006',1)
                 NEXT  FIELD vma03_1
             END IF
             IF not cl_null(g_vma[l_ac].vma03_1) THEN
                LET g_vma[l_ac].vma03 = g_vma[l_ac].vma03_1[1,2]*60*60 +
                            g_vma[l_ac].vma03_1[4,5]*60 +
                            g_vma[l_ac].vma03_1[7,8]
                DISPLAY BY NAME  g_vma[l_ac].vma03
                IF not cl_null(g_vma[l_ac].vma03) THEN
                   IF g_vma[l_ac].vma02>g_vma[l_ac].vma03 THEN
                      CALL cl_err('','mfg9234',1)
                      LET g_vma[l_ac].vma03_1 = g_vma_t.vma03_1
                      LET g_vma[l_ac].vma03   = g_vma_t.vma03
                      NEXT FIELD vma03_1
                   END IF
                END IF
             ELSE
                LET g_vma[l_ac].vma03_1 = '00:00:00'
                LET g_vma[l_ac].vma03  = '0'
                NEXT FIELD vma03_1
             END IF
 
 
 
        AFTER FIELD vma02               #check 編號是否重複
            IF NOT cl_null(g_vma[l_ac].vma02) THEN
                IF (g_vma_t.vma01 != g_vma[l_ac].vma01 OR
                    g_vma_t.vma02 != g_vma[l_ac].vma02 OR
                    p_cmd='a') THEN
                    SELECT count(*) INTO l_n FROM vma_file
                     WHERE vma01 = g_vma[l_ac].vma01
                       AND vma02 = g_vma[l_ac].vma02
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_vma[l_ac].vma01 = g_vma_t.vma01
                        LET g_vma[l_ac].vma02 = g_vma_t.vma02
                        NEXT FIELD vma02
                    END IF
                END IF
            END IF
            #--NO.FUN-850114 start--
            IF g_vma[l_ac].vma02 < 0 THEN
                NEXT FIELD vma02
            END IF
            #--NO.FUN-850114 end----
 
        #--NO.FUN-850114 start--
        AFTER FIELD vma03
            IF g_vma[l_ac].vma03 < 0 THEN
                NEXT FIELD vma03
            END IF
        #--NO.FUN-850114 end----
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_vma_t.vma01) THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               #FUN-B80181 add str---
                SELECT count(*) INTO l_n FROM vmb_file
                 WHERE vmb03 = g_vma_t.vma01
                IF l_n > 0 THEN
                    CALL cl_err('','aps-804',0)
                    LET g_vma[l_ac].vma01 = g_vma_t.vma01
                    CANCEL DELETE
                END IF
                SELECT count(*) INTO l_n FROM vmc_file
                 WHERE vmc02 = g_vma_t.vma01
                    OR vmc03 = g_vma_t.vma01
                    OR vmc04 = g_vma_t.vma01
                    OR vmc05 = g_vma_t.vma01
                    OR vmc06 = g_vma_t.vma01
                    OR vmc07 = g_vma_t.vma01
                    OR vmc08 = g_vma_t.vma01
                IF l_n > 0 THEN
                   CALL cl_err('','aps-805',0)
                   LET g_vma[l_ac].vma01 = g_vma_t.vma01
                   CANCEL DELETE
                END IF
               #FUN-B80181 add end---
                DELETE FROM vma_file
                 WHERE vma01 = g_vma_t.vma01
                   AND vma02 = g_vma_t.vma02
                IF SQLCA.sqlcode THEN
 #                  CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
                CALL cl_err3("del","vma_file",g_vma_t.vma01,g_vma_t.vma02,SQLCA.sqlcode,"","",1)  # Fun - 660095
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i300_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_vma[l_ac].* = g_vma_t.*
              CLOSE i300_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_vma[l_ac].vma01,-263,1)
              LET g_vma[l_ac].* = g_vma_t.*
           ELSE
           #FUN-870099  adjust 更新條件
              UPDATE vma_file SET
                                  vma01 = g_vma[l_ac].vma01,
                                  vma02 = g_vma[l_ac].vma02,
                                  vma03 = g_vma[l_ac].vma03,
                                  vma04 = g_vma[l_ac].vma04,
                                  vma05 = g_vma[l_ac].vma05,
                                  vma06 = g_vma[l_ac].vma06
               WHERE vma01=g_vma_t.vma01 and vma02=g_vma_t.vma02
 #              WHERE CURRENT OF i300_bcl
              IF SQLCA.sqlcode THEN
 #                 CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
                CALL cl_err3("upd","vma_file",g_vma_t.vma01,g_vma_t.vma02,SQLCA.sqlcode,"","",1)  # Fun - 660095
                  LET g_vma[l_ac].* = g_vma_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i300_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_vma[l_ac].* = g_vma_t.*
               END IF
               CLOSE i300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i300_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i300_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vma01) AND l_ac > 1 THEN
                LET g_vma[l_ac].* = g_vma[l_ac-1].*
                NEXT FIELD vma01
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
 
    CLOSE i300_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i300_b_askkey()
    CLEAR FORM
    CALL g_vma.clear()
    #FUN-870099  查詢條件過濾掉開始時間,結束時間 vma02,vma03
    CONSTRUCT g_wc2 ON vma01,vma04,vma05,vma06
            FROM s_vma[1].vma01,
                 s_vma[1].vma04,s_vma[1].vma05, s_vma[1].vma06
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i300_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(500)
 
    LET g_sql =
        "SELECT vma01,'',vma02,'',vma03,vma04,vma05,vma06, ",
       #"       CAST(vma02/3600 AS INT) vma02_1a,CAST((vma02-(CAST(vma02/3600 AS INT)*3600))/60 AS INT) vma02_1b,MOD(vma02,60) vma02_1c, ",  #FUN-B50004 mod #FUN-D10140 mark
        "      FLOOR(vma02/3600)        vma02_1a,FLOOR((vma02-(FLOOR(vma02/3600)*3600))/60)             vma02_1b,MOD(vma02,60) vma02_1c, ",                  #FUN-D10140 add
       #"       CAST(vma03/3600 AS INT) vma03_1a,CAST((vma03-(CAST(vma03/3600 AS INT)*3600))/60 AS INT) vma03_1b,MOD(vma03,60) vma03_1c  ",  #FUN-B50004 mod #FUN-D10140 mark
        "      FLOOR(vma03/3600)        vma03_1a,FLOOR((vma03-(FLOOR(vma03/3600)*3600))/60)             vma03_1b,MOD(vma03,60) vma03_1c  ",                  #FUN-D10140 add
        " FROM vma_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY vma01"
    PREPARE i300_pb FROM g_sql
    DECLARE vma_file_curs CURSOR FOR i300_pb
 
    CALL g_vma.clear()
    LET g_cnt = 1
    FOREACH vma_file_curs INTO g_vma[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
 
       #FUN-870099  TIME FORMAT -----begin-------
 
       IF g_vma[g_cnt-1].vma02_1a=0 then 
          LET g_vma[g_cnt-1].vma02_1 = '00:'
       ELSE
         IF g_vma[g_cnt-1].vma02_1a<10 then
            LET g_vma[g_cnt-1].vma02_1 = '0',g_vma[g_cnt-1].vma02_1a using '#',':'
         ELSE
            LET g_vma[g_cnt-1].vma02_1 = g_vma[g_cnt-1].vma02_1a using '##',':'
         END IF
       END IF  
       IF g_vma[g_cnt-1].vma02_1b=0 then
          LET g_vma[g_cnt-1].vma02_1 = g_vma[g_cnt-1].vma02_1,'00:'
       ELSE
         IF g_vma[g_cnt-1].vma02_1b<10 then
            LET g_vma[g_cnt-1].vma02_1 = g_vma[g_cnt-1].vma02_1,'0',g_vma[g_cnt-1].vma02_1b using '#',':'
         ELSE
            LET g_vma[g_cnt-1].vma02_1 = g_vma[g_cnt-1].vma02_1,g_vma[g_cnt-1].vma02_1b using '##',':'
         END IF
       END IF
       IF g_vma[g_cnt-1].vma02_1c=0 then
          LET g_vma[g_cnt-1].vma02_1 = g_vma[g_cnt-1].vma02_1,'00'
       ELSE
          IF g_vma[g_cnt-1].vma02_1c<10 then
             LET g_vma[g_cnt-1].vma02_1 = g_vma[g_cnt-1].vma02_1,'0',g_vma[g_cnt-1].vma02_1c using '#'
          ELSE
             LET g_vma[g_cnt-1].vma02_1 = g_vma[g_cnt-1].vma02_1,g_vma[g_cnt-1].vma02_1c using '##'
          END IF
       END IF
 
       IF g_vma[g_cnt-1].vma03_1a=0 then
          LET g_vma[g_cnt-1].vma03_1 = '00:'
          ELSE
             IF g_vma[g_cnt-1].vma03_1a<10 then
                LET g_vma[g_cnt-1].vma03_1 = '0',g_vma[g_cnt-1].vma03_1a using '#',':'
                ELSE
                   LET g_vma[g_cnt-1].vma03_1 = g_vma[g_cnt-1].vma03_1a using '##',':'
             END IF
       END IF
       IF g_vma[g_cnt-1].vma03_1b=0 then
          LET g_vma[g_cnt-1].vma03_1 = g_vma[g_cnt-1].vma03_1,'00:'
          ELSE
             IF g_vma[g_cnt-1].vma03_1b<10 then
                LET g_vma[g_cnt-1].vma03_1 = g_vma[g_cnt-1].vma03_1,'0',g_vma[g_cnt-1].vma03_1b using '#',':'
                ELSE
                   LET g_vma[g_cnt-1].vma03_1 = g_vma[g_cnt-1].vma03_1,g_vma[g_cnt-1].vma03_1b using '##',':'
             END IF
       END IF
       IF g_vma[g_cnt-1].vma03_1c=0 then
          LET g_vma[g_cnt-1].vma03_1 = g_vma[g_cnt-1].vma03_1,'00'
          ELSE
             IF g_vma[g_cnt-1].vma03_1c<10 then
                LET g_vma[g_cnt-1].vma03_1 = g_vma[g_cnt-1].vma03_1,'0',g_vma[g_cnt-1].vma03_1c using '#'
                ELSE
                   LET g_vma[g_cnt-1].vma03_1 = g_vma[g_cnt-1].vma03_1,g_vma[g_cnt-1].vma03_1c using '##'
             END IF
       END IF
       #FUN-870099  TIME FORMAT ---end----
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vma.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vma TO s_vma.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-570110--begin
FUNCTION i300_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("vma01,vma02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i300_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("vma01,vma02",FALSE)
   END IF
END FUNCTION
#No.FUN-570110--end
#Patch....NO.TQC-610036 <001> #
