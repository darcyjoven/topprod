# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: sabmi300.4gl
# Descriptions...: E-BOM 插件位置維護
# Date & Author..: 98/04/29 By Raymon
# Modify.........: 2000/01/04 By Kammy (加版本)
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560027 05/06/13 By Mandy 特性BOM+KEY 值bmu08
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.TQC-660046 06/06/13 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-740189 07/04/23 By Carol 插件位置是否勾稽是由參數設定(aimi100)來決定, 'Y'則不match不可離開
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bmp           RECORD LIKE bmp_file.*,
    g_bmp_t         RECORD LIKE bmp_file.*,
    g_bmp01_t       LIKE bmp_file.bmp01,   #主件編號-1 (舊值)
    g_bmp28_t       LIKE bmp_file.bmp28,   #FUN-560027 add
    g_bmp02_t       LIKE bmp_file.bmp02,   #項次-2 (舊值)
    g_bmp03_t       LIKE bmp_file.bmp03,   #元件編號-3 (舊值)
    g_bmp04_t       LIKE bmp_file.bmp04,   #生效日-4 (舊值)
    g_bmu           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmu05       LIKE bmu_file.bmu05,   #行序
        bmu06       LIKE bmu_file.bmu06,   #插件位置
        bmu07       LIKE bmu_file.bmu07    #組成用量
                    END RECORD,
    g_bmu_t         RECORD                 #程式變數 (舊值)
        bmu05       LIKE bmu_file.bmu05,   #行序
        bmu06       LIKE bmu_file.bmu06,   #插件位置
        bmu07       LIKE bmu_file.bmu07    #組成用量
                    END RECORD,
   #g_wc,g_wc2,g_sql    STRING, #TQC-630166
    g_wc,g_wc2,g_sql    STRING,    #TQC-630166
    g_flag          LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT     #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5,   #目前處理的SCREEN LINE   #No.FUN-680096 SMALLINT
    g_qpa           LIKE bmp_file.bmp06,   #FUN-550106                  #FUN-560231
    g_tot	    LIKE bmp_file.bmp06,   #組成用量總計   #FUN-550106  #FUN-560231
    g_ima147        LIKE ima_file.ima147
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-570110  #No.FUN-680096 SMALLINT
#主程式開始
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
FUNCTION i300(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7,p_argv8) #FUN-560027 add p_argv8
DEFINE
#       l_time    LIKE type_file.chr8              #No.FUN-6A0060
    p_argv1         LIKE bmp_file.bmp01,
    p_argv2         LIKE bmp_file.bmp02,
    p_argv3         LIKE bmp_file.bmp03,
    p_argv4         LIKE bmp_file.bmp04,
    p_argv5         LIKE type_file.chr1,    #'a'/'u' #No.FUN-680096 VARCHAR(1)
    p_argv6         LIKE bmp_file.bmp06,
    p_argv7         LIKE bmp_file.bmp011,
    p_argv8         LIKE bmp_file.bmp28     #FUN-560027 add
DEFINE ls_tmp     STRING
 
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
    LET g_bmp.bmp01  = p_argv1	           #主件編號
    LET g_bmp.bmp02  = p_argv2	           #項次
    LET g_bmp.bmp03  = p_argv3			   #元件
    LET g_bmp.bmp04  = p_argv4		       #生效日
    LET g_qpa        = p_argv6             #QPA
    LET g_bmp.bmp011 = p_argv7             #版本
    LET g_bmp.bmp28  = p_argv8             #FUN-560027 add
 
    LET p_row = 6 LET p_col = 34
    OPEN WINDOW i300_w AT p_row,p_col             #顯示畫面
         WITH FORM "abm/42f/abmi201"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi201")
 
    CALL g_bmu.clear()
    LET g_bmp.bmp03  = p_argv3			   #元件
    LET g_ima147 = NULL
    SELECT ima147 INTO g_ima147 #BugNo:6542
      FROM ima_file
     WHERE ima01 = g_bmp.bmp03
    IF SQLCA.sqlcode=100 THEN
        SELECT bmq147 INTO g_ima147 #BugNo:6542
          FROM bmq_file
         WHERE bmq01 = g_bmp.bmp03
    END IF
    LET g_rec_b = 0
    CALL i300_show()
    CALL i300_b()
    CLOSE WINDOW i300_w                 #結束畫面
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i300_show()
    LET g_bmp_t.* = g_bmp.*                #保存單頭舊值
    LET g_bmp.bmp06 = g_qpa
    DISPLAY BY NAME g_bmp.bmp06
    CALL i300_b_fill(" 1=1")   #單身
# genero  script marked     LET g_bmu_pageno = 0
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用    #No.FUN-680096 SMALLINT
    l_i             LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否    #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態      #No.FUN-680096 VARCHAR(1)
    l_k             LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    l_tot           LIKE bmp_file.bmp06,
    l_amt           LIKE bmp_file.bmp06,
    l_allow_insert  LIKE type_file.num5,     #可新增否   #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否   #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0)  THEN RETURN END IF
    IF g_bmp.bmp01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT bmu05,bmu06,bmu07 ",
       "FROM bmu_file ",
       " WHERE bmu01  = ? ",
       "  AND bmu02  = ? ",
       "  AND bmu03  = ? ",
       "  AND bmu011 = ? ",
       "  AND bmu05  = ? ",
       "  AND bmu08  = ? ",  #FUN-560027 add
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
    WHILE TRUE #TQC-740189(ADD WHILE....END WHILE)
        INPUT ARRAY g_bmu
              WITHOUT DEFAULTS
              FROM s_bmu.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
 
               LET g_bmu_t.* = g_bmu[l_ac].*  #BACKUP
#No.FUN-570110 --start--
               LET g_before_input_done = FALSE
               CALL i300_set_entry(p_cmd)
               CALL i300_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110 --end--
                OPEN i300_bcl USING g_bmp.bmp01,g_bmp.bmp02,g_bmp.bmp03,g_bmp.bmp011,g_bmu_t.bmu05,g_bmp.bmp28 #FUN-560027 add bmp28
                IF STATUS THEN
                    CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                ELSE
                    FETCH i300_bcl INTO g_bmu[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmu_t.bmu05,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bmu05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO bmu_file(bmu01,bmu011,bmu02,bmu03,
                                 bmu04,bmu05,bmu06,bmu07,bmu08) #FUN-560027 add bmu08
            VALUES(g_bmp.bmp01,g_bmp.bmp011,g_bmp.bmp02,g_bmp.bmp03,
                   g_bmp.bmp04,g_bmu[l_ac].bmu05,g_bmu[l_ac].bmu06,
                   g_bmu[l_ac].bmu07,g_bmp.bmp28) #FUN-560027 add bmp28
            IF SQLCA.sqlcode THEN
         #      CALL cl_err(g_bmu[l_ac].bmu05,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("ins","bmu_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)    #No.TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
#No.FUN-570110 --start--
            LET g_before_input_done = FALSE
            CALL i300_set_entry(p_cmd)
            CALL i300_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110 --end--
            LET l_n = ARR_COUNT()
            INITIALIZE g_bmu[l_ac].* TO NULL      #900423
            LET g_bmu_t.* = g_bmu[l_ac].*         #新輸入資料
            LET g_bmu[l_ac].bmu07 = 1
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmu05
 
        BEFORE FIELD bmu05                        #default 序號
            IF g_bmu[l_ac].bmu05 = 0 THEN  NEXT FIELD bmu06 END IF
            IF g_bmu[l_ac].bmu05 IS NULL OR
               g_bmu[l_ac].bmu05 = 0
            THEN
                SELECT max(bmu05)
                   INTO g_bmu[l_ac].bmu05
                   FROM bmu_file
                   WHERE bmu01 = g_bmp.bmp01
                     AND bmu02 = g_bmp.bmp02
                     AND bmu03 = g_bmp.bmp03
                     AND bmu011= g_bmp.bmp011
                     AND bmu08 = g_bmp.bmp28 #FUN-560027 add
                IF g_bmu[l_ac].bmu05 IS NULL THEN
                    LET g_bmu[l_ac].bmu05 = 0
                END IF
                LET g_bmu[l_ac].bmu05 = g_bmu[l_ac].bmu05 + g_sma.sma19
            END IF
 
        AFTER FIELD bmu05                        #check 序號是否重複
            IF g_bmu[l_ac].bmu05 != g_bmu_t.bmu05 OR
               g_bmu_t.bmu05 IS NULL THEN
                SELECT count(*)
                    INTO l_n
                    FROM bmu_file
                    WHERE bmu01 = g_bmp.bmp01
                      AND bmu02 = g_bmp.bmp02
                      AND bmu03 = g_bmp.bmp03
                      AND bmu011= g_bmp.bmp011
                      AND bmu05 = g_bmu[l_ac].bmu05
                      AND bmu08 = g_bmp.bmp28 #FUN-560027 add
                IF l_n > 0 THEN
                    CALL cl_err(g_bmu[l_ac].bmu05,-239,0)
                    LET g_bmu[l_ac].bmu05 = g_bmu_t.bmu05
                    NEXT FIELD bmu05
                END IF
            END IF
 
 
        AFTER FIELD bmu07
            IF NOT cl_null(g_bmu[l_ac].bmu07) THEN
                IF g_bmu[l_ac].bmu07 <=0 THEN
                    NEXT FIELD bmu07
                END IF
                IF g_bmu[l_ac].bmu07 > g_bmp.bmp06 AND g_ima147 = 'Y' #no.6542
                THEN CALL cl_err(g_bmu_t.bmu07,'mfg2766',0)
                     NEXT FIELD bmu07
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmu_t.bmu05 > 0 AND
               g_bmu_t.bmu05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bmu_file
                    WHERE bmu01 = g_bmp.bmp01 AND bmu02 = g_bmp.bmp02  AND
                          bmu03 = g_bmp.bmp03 AND bmu011= g_bmp.bmp011 AND
                          bmu05 = g_bmu_t.bmu05
                      AND bmu08 = g_bmp.bmp28 #FUN-560027 add
                IF SQLCA.sqlcode THEN
       #            CALL cl_err(g_bmu_t.bmu05,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("del","bmu_file",g_bmp.bmp01,g_bmp.bmp011,SQLCA.sqlcode,"","",1)   #No.TQC-660046
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmu[l_ac].* = g_bmu_t.*
               CLOSE i300_bcl
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmu[l_ac].bmu05,-263,1)
                LET g_bmu[l_ac].* = g_bmu_t.*
            ELSE
                UPDATE bmu_file SET
                   bmu05 = g_bmu[l_ac].bmu05,
                   bmu06 = g_bmu[l_ac].bmu06,
                   bmu07 = g_bmu[l_ac].bmu07
                 WHERE bmu01  = g_bmp.bmp01
                   AND bmu02  = g_bmp.bmp02
                   AND bmu03  = g_bmp.bmp03
                   AND bmu011 = g_bmp.bmp011
                   AND bmu05  = g_bmu_t.bmu05
                   AND bmu08  = g_bmp.bmp28 #FUN-560027 add
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bmu[l_ac].bmu05,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","bmu_file",g_bmp.bmp01,g_bmp.bmp02,SQLCA.sqlcode,"","",1)   #No.TQC-660046
                    LET g_bmu[l_ac].* = g_bmu_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                END IF
            END IF
            CALL i300_tot() #組成用量加總
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmu[l_ac].* = g_bmu_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmu.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i300_bcl
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CALL i300_tot() #組成用量加總
          #CKP
          #LET g_bmu_t.* = g_bmu[l_ac].*          # 900423
            CLOSE i300_bcl
 
      # ON ACTION CONTROLN
      #     CALL i300_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmu05) AND l_ac > 1 THEN
                LET g_bmu[l_ac].* = g_bmu[l_ac-1].*
                NEXT FIELD bmu05
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
        CALL i300_chk_QPA()
#TQC-740189-add
        IF cl_null(g_errno) THEN
            EXIT WHILE
        ELSE
            CONTINUE WHILE
        END IF
    END WHILE
#TQC-740189-end
 
    CLOSE i300_bcl
END FUNCTION
 
FUNCTION i300_b_askkey()
DEFINE
   #l_wc2           STRING #TQC-630166    
    l_wc2           STRING    #TQC-630166
 
    CONSTRUCT l_wc2 ON bmu05,bmu06,bmu07
            FROM s_bmu[1].bmu05,s_bmu[1].bmu06,s_bmu[1].bmu07
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
    LET l_wc2 = l_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        RETURN
#    END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET l_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i300_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           STRING #TQC-630166     
    p_wc2           STRING    #TQC-630166
 
    LET g_sql =
        "SELECT bmu05,bmu06,bmu07",
        " FROM bmu_file",
        " WHERE bmu01 ='",g_bmp.bmp01,"' AND",   #單頭-1
              " bmu011='",g_bmp.bmp011,"' AND",  #單頭-2
              " bmu02 = ",g_bmp.bmp02,"  AND",   #單頭-3
              " bmu03 ='",g_bmp.bmp03,"' AND",   #單頭-4
              " bmu08 ='",g_bmp.bmp28,"' AND",   #FUN-560027 add
        p_wc2 CLIPPED,                           #單身
        " ORDER BY 1"
    PREPARE i300_pb FROM g_sql
    DECLARE bmu_cs                       #CURSOR
        CURSOR FOR i300_pb
 
    CALL g_bmu.clear()
    LET g_cnt 	= 1
    LET g_rec_b = 0
    LET g_tot = 0
    FOREACH bmu_cs INTO g_bmu[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_tot = g_tot + g_bmu[g_cnt].bmu07
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    #CKP
    CALL g_bmu.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_tot TO FORMONLY.tot	
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i300_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bmp01       LIKE bmp_file.bmp01,   #主件編號
        bmp02       LIKE bmp_file.bmp02,   #項次
        bmp03       LIKE bmp_file.bmp03,   #元件編號
        bmp04       LIKE bmp_file.bmp04,   #生效日
        bmu05       LIKE bmu_file.bmu05,   #行序
        bmu06       LIKE bmu_file.bmu06,   #說明
	bmu07	    LIKE bmu_file.bmu07
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
 
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','abm-730',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'abmi300.out'
    CALL cl_outnam('abmi300') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmi300'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT bmp01,bmp02,bmp03,bmp04,bmu05,bmu06,bmu07 ",
          " FROM bmp_file,bmu_file ",
          " WHERE bmu01=bmp01 AND bmu02=bmp02 ",
          " AND bmu03=bmp03   AND bmu011=bmp011 ",
          " AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i300_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i300_co                         # CURSOR
        CURSOR FOR i300_p1
 
    START REPORT i300_rep TO l_name
 
    FOREACH i300_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i300_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i300_rep
 
    CLOSE i300_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i300_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bmp01       LIKE bmp_file.bmp01,   #主件編號
        bmp02       LIKE bmp_file.bmp02,   #項次
        bmp03       LIKE bmp_file.bmp03,   #元件編號
        bmp04       LIKE bmp_file.bmp04,   #生效日
        bmu05       LIKE bmu_file.bmu05,   #行序
        bmu06       LIKE bmu_file.bmu06,   #說明
        bmu07       LIKE bmu_file.bmu07    #說明
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bmp01,sr.bmp02,sr.bmp03,sr.bmp04,sr.bmu05
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT g_x[11],g_x[12]
            PRINT '-------------------- ---- --------------',
				  '------ -------- ---- ---------- --------'
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.bmp04  #項次
            LET g_cnt=1
            PRINT COLUMN 1 ,sr.bmp01 CLIPPED,
				  COLUMN 22,sr.bmp02 using '###&',
                  COLUMN 27,sr.bmp03 CLIPPED,
				  COLUMN 48,sr.bmp04 CLIPPED;
		ON EVERY ROW
			PRINT COLUMN 57,sr.bmu05 using '###&',
				  COLUMN 62,sr.bmu06 CLIPPED,
				  COLUMN 73,sr.bmu07 CLIPPED
	
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN#IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                    PRINT g_dash[1,g_len]
            END IF
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
FUNCTION i300_chk_QPA()
        LET g_errno = NULL
        IF g_ima147 = 'Y' AND (g_tot != g_qpa) THEN
            LET g_errno = 'mfg2765'
            #組成用量的總數不符合, 請重新輸入
            CALL cl_err(g_tot,g_errno,0)
        END IF
END FUNCTION
FUNCTION i300_tot()  #組成用量加總
    DEFINE l_i LIKE type_file.num10   #No.FUN-680096 INTEGER
        LET g_tot = 0
 
        FOR l_i = 1 TO g_bmu.getLength()
            IF cl_null(g_bmu[l_i].bmu06) THEN
                EXIT FOR
            END IF
            LET g_tot   = g_tot + g_bmu[l_i].bmu07
        END FOR
        DISPLAY g_tot TO FORMONLY.tot
END FUNCTION
 
#No.FUN-570110 --start--
FUNCTION i300_set_entry(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("bmu05",TRUE)
  END IF
 
END FUNCTION
 
 
FUNCTION i300_set_no_entry(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("bmu05",FALSE)
   END IF
 
END FUNCTION
#No.FUN-570110 --end--
#Patch....NO.TQC-610035 <001> #
