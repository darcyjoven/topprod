# Prog. Version..: '5.10.00-08.01.04(00004)'     #
#
# Pattern name...: axdp200.4gl
# Descriptions...: 調撥單結案作業
# Input parameter:
# Return code....:
# Date & Author..: 03/12/31 By Carrier
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No:FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
   tm RECORD
      add01    LIKE add_file.add01,   #調撥申請單號
      add02    LIKE add_file.add02,   #申請日期
      a        LIKE type_file.chr1,   #是否整張申請單全部設定結案   #No.FUN-680108 VARCHAR(1)
      y        LIKE type_file.chr1    #已結案資料是否顯示           #No.FUN-680108 VARCHAR(1)
   END RECORD,
   g_ade    DYNAMIC ARRAY OF RECORD
        ade13    LIKE ade_file.ade13,     # 結案否
        ade02    LIKE ade_file.ade02,     # 項次
        ade03    LIKE ade_file.ade03,     # 料號
        ade05    LIKE ade_file.ade05,     # 申請量
        ade12    LIKE ade_file.ade12,     # 已調撥量
        ade15    LIKE ade_file.ade12      # 已撥入量
        END RECORD,
   g_ade_t  RECORD
        ade13    LIKE ade_file.ade13,     # 結案否
        ade02    LIKE ade_file.ade02,     # 項次
        ade03    LIKE ade_file.ade03,     # 料號
        ade05    LIKE ade_file.ade05,     # 申請量
        ade12    LIKE ade_file.ade12,     # 已調撥量
        ade15    LIKE ade_file.ade12      # 已撥入量
        END RECORD,
    g_add00      LIKE add_file.add00,
    g_cmd        LIKE type_file.chr1000,  #No.FUN-680108 VARCHAR(60)
    g_sql        string,                  #No:FUN-580092 HCN
    g_rec_b      LIKE type_file.num5,     #No.FUN-680108 SMALLINT
    l_exit_sw    LIKE type_file.chr1,     #No.FUN-680108 VARCHAR(1)
    l_ac         LIKE type_file.num5      #No.FUN-680108 SMALLINT
DEFINE   g_cnt    LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_choice STRING

MAIN
   OPTIONS
      FORM LINE     FIRST + 2,
      MESSAGE LINE  LAST,
      PROMPT LINE   LAST,
      INPUT NO WRAP,
      INSERT KEY F13,
      DELETE KEY F13
   DEFER INTERRUPT                # Supress DEL key function
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
    CALL p200_tm(0,0)
END MAIN

FUNCTION p200_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680108 SMALLINT

       LET p_row = 3 LET p_col = 2

   OPEN WINDOW p200_w AT p_row,p_col
        WITH FORM "axd/42f/axdp200"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
   
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM
   INITIALIZE tm.* TO NULL            # Default condition
      LET tm.a = 'N'
      LET tm.y = 'N'
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

      INPUT BY NAME tm.add01,tm.a,tm.y     WITHOUT DEFAULTS HELP 1
          AFTER FIELD add01            #請購單號
            IF NOT cl_null(tm.add01) THEN
               CALL p200_add01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.add01,g_errno,0)
                  NEXT FIELD add01
               END IF
            END IF

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(add01) #單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_add" 
                    LET g_qryparam.default1 = tm.add01                  
                    CALL cl_create_qry() RETURNING tm.add01             
                    DISPLAY tm.add01 TO add01 #ATTRIBUTE(YELLOW)
                    CALL p200_add01()
                    NEXT FIELD add01
            END CASE

        ON ACTION appl_no_detail
            CASE
               WHEN INFIELD(add01) #單號
                  SELECT add00 INTO g_add00 FROM add_file
                   WHERE add01 = tm.add01
                  LET g_cmd = "axdt201 '",g_add00,"' '",tm.add01,"'"
                  #CALL  cl_cmdrun(g_cmd)      #FUN-660216 remark
                  CALL  cl_cmdrun_wait(g_cmd)  #FUN-660216 add
            END CASE
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 

      END INPUT
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
      LET g_success='Y'
      BEGIN WORK
      CALL p200_foreach()
      IF tm.a = 'Y' THEN
         IF cl_sure(0,0) THEN
            CALL cl_wait()
            CALL axdp200()
         END IF
      ELSE
         CALL p200_b()
      END IF
      IF g_success = 'Y' THEN
         CALL cl_cmmsg(1) COMMIT WORK
      ELSE
         CALL cl_rbmsg(1) ROLLBACK WORK
      END IF
#     CALL cl_setwait(g_waitsec)   bug by 20040517
      IF l_exit_sw = 'n' THEN CALL cl_end(0,0) END IF
  
 END WHILE
   ERROR ""
   CLOSE WINDOW p200_w
END FUNCTION
 
FUNCTION p200_add01()
   DEFINE l_n           LIKE type_file.num5          #No.FUN-680108 SMALLINT
   DEFINE l_add06       LIKE add_file.add06,
          l_add07       LIKE add_file.add07,
          l_add01       LIKE add_file.add01,
          l_addconf     LIKE add_file.addconf,
          l_addacti     LIKE add_file.addacti,
          l_add02       LIKE add_file.add02
   DEFINE l_ade 	RECORD LIKE ade_file.*

   LET g_errno=' '
   SELECT add00,add01,add02,add06,add07,addconf,addacti
     INTO g_add00,l_add01,l_add02,l_add06,l_add07,l_addconf,l_addacti
     FROM add_file WHERE add01 = tm.add01
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3207'
      WHEN l_add06 <> '1'      LET g_errno = 'axd-042'
      WHEN l_add07 = 'Y'       LET g_errno = 'axd-043'
      WHEN l_addconf = 'N'     LET g_errno = 'mfg3550'
      WHEN l_addacti = 'N'     LET g_errno = '9028'
      OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
   IF cl_null(g_errno) THEN
      DISPLAY l_add02 TO add02
   END IF
END FUNCTION

FUNCTION p200_foreach()
   DEFINE
   l_wc          LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(200)
   l_sql         LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(600)
   l_cnt         LIKE type_file.num5           #No.FUN-680108 SMALLINT

   LET l_sql = " SELECT ade13,ade02,ade03,ade05,ade12,ade15 ",
               "  FROM ade_file,add_file",
               " WHERE ade01=add01"
   IF tm.y matches'[yY]' THEN
      LET l_wc   = "  AND ade01 = '",tm.add01,"'",
                   "  ORDER BY ade02 "
   ELSE
      LET l_wc   = "  AND ade01 = '",tm.add01,"' AND ",
                   "  ade13 = 'N' ",
                   "  ORDER BY ade02 "
   END IF
   LET l_sql = l_sql clipped,l_wc clipped
   PREPARE p200_prepare FROM l_sql
   DECLARE p200_cur CURSOR FOR p200_prepare
   #LET l_ac = 1
   LET g_cnt = 1
   CALL g_ade.clear()
   #FOREACH p200_cur INTO g_ade[l_ac].*
   FOREACH p200_cur INTO g_ade[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #LET l_ac = l_ac + 1
      #IF l_ac > g_max_rec THEN EXIT FOREACH END IF
      # TQC-630105----------start add by Joe
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      # TQC-630105----------end add by Joe
   END FOREACH
   #LET l_cnt = l_ac - 1
   LET l_cnt = g_cnt - 1
   LET g_rec_b=l_cnt
   DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
   LET g_cnt = 0
END FUNCTION

FUNCTION p200_b()
 DEFINE
    l_exit_sw       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)     
    l_n,l_i         LIKE type_file.num5          #No.FUN-680108 SMALLINT

    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    INPUT ARRAY g_ade WITHOUT DEFAULTS FROM s_ade.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec, UNBUFFERED)

        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_ade_t.* = g_ade[l_ac].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)

        AFTER FIELD ade13
            IF g_ade_t.ade13 = 'Y' THEN
               IF cl_null(g_ade[l_ac].ade13) OR g_ade[l_ac].ade13 = 'N' THEN
                  LET g_ade[l_ac].ade13 = g_ade_t.ade13
                  NEXT FIELD ade13
               END IF
            END IF
            IF cl_null(g_ade[l_ac].ade13)
               OR g_ade[l_ac].ade13 NOT MATCHES '[YN]' THEN
               IF g_ade[l_ac].ade02 IS NOT NULL THEN
                  NEXT FIELD ade13
               END IF
            END IF
            IF g_ade[l_ac].ade13 = 'Y' THEN
               IF g_ade_t.ade13 <> g_ade[l_ac].ade13 THEN
                  IF g_ade[l_ac].ade05 <> g_ade[l_ac].ade12 THEN
                     IF NOT cl_confirm('axd-044') THEN
                        LET g_ade[l_ac].ade13 = g_ade_t.ade13
                     END IF
                  END IF
                  IF g_ade[l_ac].ade15 <> g_ade[l_ac].ade12 THEN
                     IF NOT cl_confirm('axd-045') THEN
                        LET g_ade[l_ac].ade13 = g_ade_t.ade13
                     END IF
                  END IF
               END IF
            END IF

        AFTER ROW
            IF cl_null(g_ade[l_ac].ade02) THEN
               INITIALIZE g_ade[l_ac].* TO NULL
            END IF
            IF g_ade[l_ac].ade13 = 'Y' AND
              (cl_null(g_ade_t.ade13) OR g_ade_t.ade13 = 'N')  THEN
               UPDATE ade_file SET ade13 = 'Y',ade14 = g_today
                WHERE ade01 = tm.add01 AND ade02 = g_ade[l_ac].ade02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ade[l_ac].ade02,SQLCA.sqlcode,0)
                  LET g_success = 'N'
                  RETURN
               END IF
               IF g_add00='2' THEN
                  CALL p200_adg(tm.add01,g_ade[l_ac].ade02)
                  IF g_success='N' THEN RETURN END IF
               END IF
            END IF

        AFTER INPUT
            IF INT_FLAG THEN LET INT_FLAG = 0 LET g_success = 'N' RETURN END IF
            SELECT COUNT(*) INTO l_n FROM ade_file WHERE ade01 = tm.add01
              AND (ade13 = 'N' OR ade13 is null OR ade13 = '')
            IF l_n = 0 THEN
               UPDATE add_file SET add07 = 'Y',add08 = g_today
                WHERE add01 = tm.add01
               IF SQLCA.sqlcode THEN
                  CALL cl_err(tm.add01,SQLCA.sqlcode,0)

                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
            IF NOT cl_sure(0,0) THEN
               LET g_success = 'N'
               RETURN
            END IF
       
          ON ACTION controls                             #No.FUN-6A0092
             CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

       END INPUT
END FUNCTION

FUNCTION axdp200()
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0091
DEFINE    l_cnt         LIKE type_file.num5,         #No.FUN-680108 SMALLINT #No.FUN-6A0091
          l_ade01       LIKE ade_file.ade01,
          l_ade02       LIKE ade_file.ade02

     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091

   SELECT COUNT(*) INTO l_cnt FROM ade_file
    WHERE ade01 = tm.add01
      AND ade05 <> ade12
   IF l_cnt > 0 THEN
      IF NOT cl_confirm('axd-046') THEN
         RETURN
      END IF
   END IF
   SELECT COUNT(*) INTO l_cnt FROM ade_file
    WHERE ade01 = tm.add01
      AND ade15 <> ade12
   IF l_cnt > 0 THEN
      IF NOT cl_confirm('axd-047') THEN
         RETURN
      END IF
   END IF

   IF g_add00='2' THEN
      DECLARE p200_c1 CURSOR FOR
       SELECT ade01,ade02 FROM ade_file
        WHERE ade01=tm.add01 AND ade13='N'
        ORDER BY ade01,ade02
   
      FOREACH p200_c1 INTO l_ade01,l_ade02
          IF STATUS THEN EXIT FOREACH END IF
          IF cl_null(l_ade01) THEN CONTINUE FOREACH END IF
          CALL p200_adg(l_ade01,l_ade02)
          IF g_success='N' THEN RETURN END IF
      END FOREACH
   END IF

   UPDATE add_file SET add07 = 'Y',add08 = g_today WHERE add01 = tm.add01
   IF SQLCA.sqlcode THEN
      CALL cl_err(tm.add01,SQLCA.sqlcode,0)
      LET g_success = 'N'
      RETURN
   END IF

   UPDATE ade_file SET ade13 = 'Y',ade14 = g_today WHERE ade01 = tm.add01
   IF SQLCA.sqlcode THEN
      CALL cl_err(tm.add01,SQLCA.sqlcode,0)
      LET g_success = 'N'
      RETURN
   END IF

END FUNCTION

FUNCTION p200_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1           #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ade TO s_ade.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit" 
         EXIT DISPLAY 

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

         ON IDLE g_idle_seconds                                                 
            CALL cl_on_idle()                                                   
            CONTINUE DISPLAY   
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION


FUNCTION p200_adg(p_ade01,p_ade02)
DEFINE p_ade01    LIKE ade_file.ade01,
       p_ade02    LIKE ade_file.ade02,
       l_adg01    LIKE adg_file.adg01,
       l_adg02    LIKE adg_file.adg02,
       l_adg09    LIKE adg_file.adg09,
       l_dbs      LIKE azp_file.azp03,
       l_pmn      RECORD LIKE pmn_file.*,
       l_n        LIKE type_file.num5          #No.FUN-680108 SMALLINT

   DECLARE p200_c1_adg CURSOR FOR
    SELECT adg01,adg02,adg09 FROM adg_file
     WHERE adg03=p_ade01 AND adg04=p_ade02
     ORDER BY adg01,adg02
   FOREACH p200_c1_adg INTO l_adg01,l_adg02,l_adg09
       IF STATUS THEN EXIT FOREACH END IF
       IF cl_null(l_adg01) THEN CONTINUE FOREACH END IF
       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_adg09
       IF SQLCA.sqlcode THEN
          CALL cl_err('',SQLCA.sqlcode,0)
          LET g_success='N' RETURN
       END IF

       LET g_sql=" UPDATE ",l_dbs CLIPPED,".pmn_file SET pmn16=?",
                 "  WHERE pmn01=? AND pmn02=?"
       PREPARE p200_upd_pmn FROM g_sql
       IF SQLCA.sqlcode THEN
          CALL cl_err('update pmn',SQLCA.sqlcode,0)
          LET g_success = 'N' RETURN
       END IF


       LET g_sql = " SELECT * FROM ",l_dbs,".pmn_file",
                   "  WHERE pmn24 = '",l_adg01,"' AND pmn25 = ",l_adg02
       PREPARE p200_p_pmn FROM g_sql
       IF SQLCA.sqlcode THEN
          CALL cl_err('select pmn',SQLCA.sqlcode,0)
          LET g_success = 'N' RETURN
       END IF
       DECLARE p200_c1_pmn SCROLL CURSOR FOR p200_p_pmn
       IF SQLCA.sqlcode THEN
          CALL cl_err('select pmn',SQLCA.sqlcode,0)
          LET g_success = 'N' RETURN
       END IF
       OPEN p200_c1_pmn
       IF SQLCA.sqlcode THEN
          CALL cl_err('',SQLCA.sqlcode,0)
       ELSE
          FETCH p200_c1_pmn INTO l_pmn.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('select pmn',SQLCA.sqlcode,0)
             LET g_success = 'N' RETURN
          END IF
       END IF
       CASE
          #正常
          WHEN l_pmn.pmn20 = l_pmn.pmn50
             EXECUTE p200_upd_pmn  USING '6',l_pmn.pmn01,l_pmn.pmn02
             IF SQLCA.sqlcode THEN
                CALL cl_err('update pmn',SQLCA.sqlcode,0)
                LET g_success = 'N' RETURN
             END IF
             IF STATUS = 100 THEN
                CALL cl_err('','apm-204',1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          #結長
          WHEN l_pmn.pmn20 < l_pmn.pmn50
             EXECUTE p200_upd_pmn  USING '7',l_pmn.pmn01,l_pmn.pmn02
             IF SQLCA.SQLCODE THEN
                CALL cl_err('',SQLCA.SQLCODE,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             IF STATUS = 100 THEN
                CALL cl_err('','apm-204',1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          OTHERWISE
             EXECUTE p200_upd_pmn  USING '8',l_pmn.pmn01,l_pmn.pmn02
             IF SQLCA.SQLCODE THEN
                CALL cl_err('',SQLCA.SQLCODE,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             IF STATUS = 100 THEN
                CALL cl_err('','apm-204',1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
       END CASE
       LET g_sql=" SELECT COUNT(*) FROM ",l_dbs CLIPPED,".pmn_file",
                 "  WHERE  pmn01='",l_pmn.pmn01,"'",
                 "    AND (pmn16 NOT IN ('6','7','8') ",
                 "     OR  pmn16 is null OR pmn16='')"
       PREPARE p200_cnt_pmn FROM g_sql
       IF SQLCA.sqlcode THEN
          CALL cl_err('select pmn count',SQLCA.sqlcode,0)
          LET g_success = 'N' RETURN
       END IF
       EXECUTE p200_cnt_pmn INTO l_n
       IF SQLCA.SQLCODE THEN
          CALL cl_err('',SQLCA.SQLCODE,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       IF l_n=0 THEN
          LET g_sql=" UPDATE ",l_dbs CLIPPED,".pmm_file SET pmm25=6",
                    "  WHERE pmm01=? "
          PREPARE p200_upd_pmm FROM g_sql
          IF SQLCA.sqlcode THEN
             CALL cl_err('update pmm',SQLCA.sqlcode,0)
             LET g_success = 'N' RETURN
          END IF
          EXECUTE p200_upd_pmm USING l_pmn.pmn01
          IF SQLCA.SQLCODE THEN
             CALL cl_err('',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       END IF
   END FOREACH
END FUNCTION
 
