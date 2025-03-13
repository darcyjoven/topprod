# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi226.4gl
# Descriptions...: 寄銷客戶對應倉庫維護作業
# Date & Author..: 06/03/28 By Sarah
# Modify.........: No.FUN-630027 06/03/28 By Sarah 新增"寄銷客戶對應倉庫維護作業"
# Modify.........: No.FUN-640039 06/04/08 By Sarah 輸入時客戶簡稱、送貨客戶簡稱沒帶
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.MOD-740416 07/04/24 By kim 輸入預設寄銷倉庫、儲位時，應該要檢查倉庫及儲位必需為 MRP 不可用倉
# Modify.........: No.MOD-7C0018 07/12/04 By claire for update語法只能使用一個table否則在informix會有錯誤
# Modify.........: No.TQC-7C0032 07/12/05 By xufeng 1、缺省寄銷倉庫檢查如果為MRP倉，那麼會提示，但是提示信息不對，不是:倉庫需為非MPR倉，應該改為:倉庫需為非MRP倉
#                                                   2、缺省出貨庫位和缺省寄銷庫位沒有作任何控管,隨便輸入都可以，這不對
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出  
# Modify.........: No.TQC-920064 09/02/20 By mike MSV BUG
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AC0087 10/12/13 By sabrina 若欄位沒有帶到tuo05，則在insert時，tuo05是null
# Modify.........: No:MOD-C30454 12/03/12 By xumeimei 預設寄銷倉庫欄位控卡必需为wip仓
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50127 13/05/30 By lixh1 修正FUN-D40103逻辑檢查
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_tuo               DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                            tuo01     LIKE tuo_file.tuo01,  
                            tuo01_ds  LIKE occ_file.occ02,  
                            tuo02     LIKE tuo_file.tuo02,
                            tuo02_ds  LIKE occ_file.occ02,  
                            tuo03     LIKE tuo_file.tuo03,  
                            tuo031    LIKE tuo_file.tuo031,  
                            tuo04     LIKE tuo_file.tuo04,  
                            tuo05     LIKE tuo_file.tuo05  
                           END RECORD,
       g_tuo_t             RECORD                 #程式變數 (舊值)
                            tuo01     LIKE tuo_file.tuo01,  
                            tuo01_ds  LIKE occ_file.occ02,  
                            tuo02     LIKE tuo_file.tuo02,
                            tuo02_ds  LIKE occ_file.occ02,  
                            tuo03     LIKE tuo_file.tuo03,  
                            tuo031    LIKE tuo_file.tuo031,  
                            tuo04     LIKE tuo_file.tuo04,  
                            tuo05     LIKE tuo_file.tuo05  
                           END RECORD,
       g_wc2,g_sql         STRING,  #No.FUN-580092 HCN   
       g_rec_b             LIKE type_file.num5,    #單身筆數            #No.FUN-680137 SMALLINT
       l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql        STRING   #SELECT ... FOR UPDATE SQL  
DEFINE g_cnt               LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE g_i                 LIKE type_file.num5     #count/index for any purpose #No.FUN-680137 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-570109               #No.FUN-680137 SMALLINT
 
MAIN
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
   OPEN WINDOW i226_w WITH FORM "axm/42f/axmi226"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
       
   LET g_wc2 = '1=1' 
   CALL i226_b_fill(g_wc2)
   CALL i226_menu()
   CLOSE WINDOW i226_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i226_menu()
   WHILE TRUE
      CALL i226_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i226_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN 
               CALL i226_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i226_out() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tuo),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i226_q()
   CALL i226_b_askkey()
END FUNCTION
 
FUNCTION i226_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680137 SMALLINT
DEFINE l_imd        RECORD LIKE imd_file.*  #MOD-740416
DEFINE l_cnt        LIKE type_file.num5   #No.TQC-7C0032
 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        #MOD-7C0018-begin-modify
        #"SELECT tuo01,a.occ02,tuo02,b.occ02,tuo03,tuo031,tuo04,tuo05 ",
        #"  FROM tuo_file,occ_file a,occ_file b ",
        #"  WHERE tuo01 = a.occ01 ",
        #"   AND tuo02 = b.occ01 ",
        #"   AND tuo01 = ? AND tuo02 = ? FOR UPDATE"
        "SELECT tuo01,'',tuo02,'',tuo03,tuo031,tuo04,tuo05 ",
        "  FROM tuo_file ",
        " WHERE tuo01 = ? AND tuo02 = ? FOR UPDATE"
        #MOD-7C0018-end-modify
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i226_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tuo WITHOUT DEFAULTS FROM s_tuo.*
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
 
          IF g_rec_b >= l_ac  THEN
             LET p_cmd='u'
             LET g_tuo_t.* = g_tuo[l_ac].*  #BACKUP
             LET g_before_input_done = FALSE                                                                                      
             CALL i226_set_entry_b(p_cmd)                                                                                         
             CALL i226_set_no_entry_b(p_cmd)                                                                                      
             LET g_before_input_done = TRUE                                                                                       
             BEGIN WORK
             OPEN i226_bcl USING g_tuo_t.tuo01,g_tuo_t.tuo02
             IF STATUS THEN
                CALL cl_err("OPEN i226_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE  
                FETCH i226_bcl INTO g_tuo[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_tuo_t.tuo01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
               #MOD-7C0018-begin-add
                SELECT occ02 INTO g_tuo[l_ac].tuo01_ds
                  FROM occ_file WHERE occ01=g_tuo[l_ac].tuo01
                SELECT occ02 INTO g_tuo[l_ac].tuo02_ds
                  FROM occ_file WHERE occ01=g_tuo[l_ac].tuo02
                DISPLAY BY NAME g_tuo[l_ac].tuo01_ds
                DISPLAY BY NAME g_tuo[l_ac].tuo02_ds
               #MOD-7C0018-end-add
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
          NEXT FIELD tuo01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          IF cl_null(g_tuo[l_ac].tuo03) THEN LET g_tuo[l_ac].tuo03 = ' ' END IF        #MOD-AC0087 add
          IF cl_null(g_tuo[l_ac].tuo031) THEN LET g_tuo[l_ac].tuo031 = ' ' END IF      #MOD-AC0087 add
          IF cl_null(g_tuo[l_ac].tuo04) THEN LET g_tuo[l_ac].tuo04 = ' ' END IF        #MOD-AC0087 add
          IF cl_null(g_tuo[l_ac].tuo05) THEN LET g_tuo[l_ac].tuo05 = ' ' END IF        #MOD-AC0087 add
          INSERT INTO tuo_file(tuo01,tuo02,tuo03,tuo031,tuo04,tuo05)
                        VALUES(g_tuo[l_ac].tuo01,g_tuo[l_ac].tuo02,
                               g_tuo[l_ac].tuo03,g_tuo[l_ac].tuo031,
                               g_tuo[l_ac].tuo04,g_tuo[l_ac].tuo05)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_tuo[l_ac].tuo01,SQLCA.sqlcode,0)   #No.FUN-660167
             CALL cl_err3("ins","tuo_file",g_tuo[l_ac].tuo01,g_tuo[l_ac].tuo02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
            #DISPLAY g_rec_b TO FORMONLY.cn2 #TQC-920064
             DISPLAY g_rec_b TO FORMONLY.cnt #TQC-920064  
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE                                                                                      
          CALL i226_set_entry_b(p_cmd)                                                                                         
          CALL i226_set_no_entry_b(p_cmd)                                                                                      
          LET g_before_input_done = TRUE                                                                                       
          INITIALIZE g_tuo[l_ac].* TO NULL      #900423
          LET g_tuo_t.* = g_tuo[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD tuo01
 
       AFTER FIELD tuo01                        #check 編號是否重複
          IF NOT cl_null(g_tuo[l_ac].tuo01) THEN
            #start FUN-640039 add
             SELECT COUNT(*) INTO l_n FROM occ_file 
              WHERE occ01 = g_tuo[l_ac].tuo01
             IF l_n = 0 THEN
                CALL cl_err(g_tuo[l_ac].tuo01,'anm-045',1)
                LET g_tuo[l_ac].tuo01 = g_tuo_t.tuo01
                DISPLAY BY NAME g_tuo[l_ac].tuo01
                NEXT FIELD tuo01
             END IF
            #end FUN-640039 add
             IF cl_null(g_tuo_t.tuo01) OR cl_null(g_tuo_t.tuo02) OR
               (g_tuo[l_ac].tuo01 != g_tuo_t.tuo01) OR
               (g_tuo[l_ac].tuo02 != g_tuo_t.tuo02) THEN
                SELECT COUNT(*) INTO l_n FROM tuo_file
                 WHERE tuo01 = g_tuo[l_ac].tuo01
                   AND tuo02 = g_tuo[l_ac].tuo02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   NEXT FIELD tuo01
                END IF
             END IF
            #start FUN-640039 add
             SELECT occ02 INTO g_tuo[l_ac].tuo01_ds
               FROM occ_file WHERE occ01=g_tuo[l_ac].tuo01
             DISPLAY BY NAME g_tuo[l_ac].tuo01_ds
            #end FUN-640039 add
          END IF
 
       AFTER FIELD tuo02
         #start FUN-640039 add
          IF NOT cl_null(g_tuo[l_ac].tuo02) THEN
             SELECT COUNT(*) INTO l_n FROM occ_file 
              WHERE occ01 = g_tuo[l_ac].tuo02
             IF l_n = 0 THEN
                CALL cl_err(g_tuo[l_ac].tuo02,'anm-045',1)
                LET g_tuo[l_ac].tuo02 = g_tuo_t.tuo02
                DISPLAY BY NAME g_tuo[l_ac].tuo02
                NEXT FIELD tuo02
             END IF
          END IF
         #end FUN-640039 add
          IF cl_null(g_tuo_t.tuo01) OR cl_null(g_tuo_t.tuo02) OR
            (g_tuo[l_ac].tuo01 != g_tuo_t.tuo01) OR
            (g_tuo[l_ac].tuo02 != g_tuo_t.tuo02) THEN
             SELECT COUNT(*) INTO l_n FROM tuo_file
              WHERE tuo01 = g_tuo[l_ac].tuo01
                AND tuo02 = g_tuo[l_ac].tuo02
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                NEXT FIELD tuo02
             END IF
            #start FUN-640039 add
             SELECT occ02 INTO g_tuo[l_ac].tuo02_ds
               FROM occ_file WHERE occ01=g_tuo[l_ac].tuo02
             DISPLAY BY NAME g_tuo[l_ac].tuo02_ds
            #end FUN-640039 add
          END IF
 
      #start FUN-640039 add
       AFTER FIELD tuo03
          IF NOT cl_null(g_tuo[l_ac].tuo03) THEN
             SELECT COUNT(*) INTO l_n FROM imd_file
              WHERE imd01=g_tuo[l_ac].tuo03
                AND imdacti='Y'
             IF l_n=0 THEN
                CALL cl_err(g_tuo[l_ac].tuo03,'mfg1100',1)
                NEXT FIELD tuo03
             END IF
          END IF
 #FUN-D40103 -------Begin--------
          IF NOT i266_ime_chk(g_tuo[l_ac].tuo03,g_tuo[l_ac].tuo031) THEN
             NEXT FIELD tuo031
          END IF
       #FUN-D40103 -------End----------
 
       AFTER FIELD tuo031
          IF cl_null(g_tuo[l_ac].tuo031) THEN
             LET g_tuo[l_ac].tuo031 = ' '
          END IF
          #FUN-D40103 -------Begin--------
          #No.TQC-7C0032    ---begin-----
       #   IF NOT cl_null(g_tuo[l_ac].tuo031) THEN
       #      LET l_cnt =0 
       #      SELECT COUNT(*) INTO l_cnt 
       #        FROM ime_file
       #       WHERE ime02=g_tuo[l_ac].tuo031
       #         AND ime01=g_tuo[l_ac].tuo03
       #         AND ime05='Y'
       #      IF l_cnt = 0 THEN
       #         CALL cl_err(g_tuo[l_ac].tuo03,'mfg0095',0)
       #         NEXT FIELD tuo031
       #      END IF
       #   END IF
          #No.TQC-7C0032    ---end-------
         #FUN-D40103 -------End----------
       #FUN-D40103 -------Begin--------
          IF NOT i266_ime_chk(g_tuo[l_ac].tuo03,g_tuo[l_ac].tuo031) THEN
             NEXT FIELD tuo031
          END IF
       #FUN-D40103 -------End----------
       AFTER FIELD tuo04
          IF NOT cl_null(g_tuo[l_ac].tuo04) THEN
            #SELECT COUNT(*) INTO l_n FROM imd_file #MOD-740416
             SELECT * INTO l_imd.* FROM imd_file #MOD-740416
              WHERE imd01=g_tuo[l_ac].tuo04
                AND imdacti='Y'
            #IF l_n=0 THEN #MOD-740416
             IF STATUS <> 0 THEN #MOD-740416
                CALL cl_err(g_tuo[l_ac].tuo04,'mfg1100',1)
                NEXT FIELD tuo04
             END IF
             #MOD-740416...............begin
             IF NOT (l_imd.imd11 MATCHES '[Yy]') THEN
                CALL cl_err(g_tuo[l_ac].tuo04,'axm-993',0)
                NEXT FIELD tuo04
             END IF 
             #MOD-C30454---mark----str--
             #IF NOT (l_imd.imd10 MATCHES '[Ss]') THEN
             #   CALL cl_err(g_tuo[l_ac].tuo04,'axm-065',0)
             #   NEXT FIELD tuo04
             #END IF 
             #MOD-C30454---mark----end--
             #MOD-C30454---add-----str--
             IF NOT (l_imd.imd10 MATCHES '[Ww]') THEN
                CALL cl_err(g_tuo[l_ac].tuo04,'axm1139',0)
                NEXT FIELD tuo04
             END IF
             #MOD-C30454---add-----end--
             IF NOT (l_imd.imd12 MATCHES '[Nn]') THEN
               #CALL cl_err(g_oaz.oaz74,'axm-067',0)
                CALL cl_err(g_tuo[l_ac].tuo04,'axm-067',0)   #No.MOD-740331
                NEXT FIELD tuo04
             END IF 
             #MOD-740416...............end
          END IF
       #FUN-D40103 -------Begin--------
          IF NOT i266_ime_chk(g_tuo[l_ac].tuo04,g_tuo[l_ac].tuo05) THEN
             NEXT FIELD tuo05
          END IF
       #FUN-D40103 -------End---------- 
       AFTER FIELD tuo05
          IF cl_null(g_tuo[l_ac].tuo05) THEN
             LET g_tuo[l_ac].tuo05 = ' '
          END IF
       #FUN-D40103 -------Begin------
      #end FUN-640039 add
          #No.TQC-7C0032    ---begin-----
       #   IF NOT cl_null(g_tuo[l_ac].tuo05) THEN
       #      LET l_cnt =0 
       #      SELECT COUNT(*) INTO l_cnt 
       #        FROM ime_file
       #       WHERE ime02=g_tuo[l_ac].tuo05
       #         AND ime01=g_tuo[l_ac].tuo04
       #         AND ime05='Y'
       #      IF l_cnt = 0 THEN
       #         CALL cl_err(g_tuo[l_ac].tuo05,'mfg0095',0)
       #         NEXT FIELD tuo05 
       #      END IF
       #   END IF
       #   #No.TQC-7C0032    ---end-------
        #FUN-D40103 -------End--------
       #FUN-D40103 -------Begin--------
          IF NOT i266_ime_chk(g_tuo[l_ac].tuo04,g_tuo[l_ac].tuo05) THEN
             NEXT FIELD tuo05
          END IF
       #FUN-D40103 -------End----------
       BEFORE DELETE                            #是否取消單身
          IF g_tuo_t.tuo01 IS NOT NULL THEN
             IF NOT cl_delete() THEN CANCEL DELETE END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
 
             DELETE FROM tuo_file 
              WHERE tuo01 = g_tuo_t.tuo01 AND tuo02 = g_tuo_t.tuo02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_tuo_t.tuo01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("del","tuo_file",g_tuo_t.tuo01,g_tuo_t.tuo02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                ROLLBACK WORK
                CANCEL DELETE 
             END IF
 
             LET g_rec_b=g_rec_b-1
            #DISPLAY g_rec_b TO FORMONLY.cn2 #TQC-920064
             DISPLAY g_rec_b TO FORMONLY.cnt #TQC-920064        
             MESSAGE "Delete OK"
             CLOSE i226_bcl
             COMMIT WORK 
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_tuo[l_ac].* = g_tuo_t.*
             CLOSE i226_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_tuo[l_ac].tuo01,-263,1)
             LET g_tuo[l_ac].* = g_tuo_t.*
          ELSE
             UPDATE tuo_file SET tuo01 =g_tuo[l_ac].tuo01,
                                 tuo02 =g_tuo[l_ac].tuo02,
                                 tuo03 =g_tuo[l_ac].tuo03,
                                 tuo031=g_tuo[l_ac].tuo031,
                                 tuo04 =g_tuo[l_ac].tuo04,
                                 tuo05 =g_tuo[l_ac].tuo05
              WHERE tuo01= g_tuo_t.tuo01 AND tuo02 = g_tuo_t.tuo02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_tuo[l_ac].tuo01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("upd","tuo_file",g_tuo_t.tuo01,g_tuo_t.tuo02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                LET g_tuo[l_ac].* = g_tuo_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i226_bcl
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
                LET g_tuo[l_ac].* = g_tuo_t.*
             #FUN-D30034--add--begin--
             ELSE
                CALL g_tuo.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end----
             END IF
             CLOSE i226_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30034 add
          CLOSE i226_bcl
          COMMIT WORK
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(tuo01)   #客戶編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ"
                  LET g_qryparam.default1 = g_tuo[l_ac].tuo01
                  CALL cl_create_qry() RETURNING g_tuo[l_ac].tuo01
                  DISPLAY BY NAME g_tuo[l_ac].tuo01
                  NEXT FIELD tuo01
             WHEN INFIELD(tuo02)   #送貨客戶
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'
                  LET g_qryparam.default1 = g_tuo[l_ac].tuo02
                  CALL cl_create_qry() RETURNING g_tuo[l_ac].tuo02
                  DISPLAY BY NAME g_tuo[l_ac].tuo02
                  NEXT FIELD tuo02
             WHEN INFIELD(tuo03)   #預設出貨倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd1"
                  LET g_qryparam.default1 = g_tuo[l_ac].tuo03
                  CALL cl_create_qry() RETURNING g_tuo[l_ac].tuo03
                  DISPLAY BY NAME g_tuo[l_ac].tuo03
                  NEXT FIELD tuo03
             WHEN INFIELD(tuo031)   #預設出貨儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ime"
                  LET g_qryparam.arg1     = g_tuo[l_ac].tuo03
                  LET g_qryparam.arg2     = 'SW'
                  LET g_qryparam.default1 = g_tuo[l_ac].tuo031
                  CALL cl_create_qry() RETURNING g_tuo[l_ac].tuo031
                  DISPLAY BY NAME g_tuo[l_ac].tuo031
                  NEXT FIELD tuo031
             WHEN INFIELD(tuo04)   #預設寄銷倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd01"
                  LET g_qryparam.default1 = g_tuo[l_ac].tuo04
                  CALL cl_create_qry() RETURNING g_tuo[l_ac].tuo04
                  DISPLAY BY NAME g_tuo[l_ac].tuo04
                  NEXT FIELD tuo04
             WHEN INFIELD(tuo05)   #預設寄銷儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ime"
                  LET g_qryparam.arg1     = g_tuo[l_ac].tuo04
                  LET g_qryparam.arg2     = 'SW'
                  LET g_qryparam.default1 = g_tuo[l_ac].tuo05
                  CALL cl_create_qry() RETURNING g_tuo[l_ac].tuo05
                  DISPLAY BY NAME g_tuo[l_ac].tuo05
                  NEXT FIELD tuo05
          END CASE
 
       ON ACTION CONTROLN
          CALL i226_b_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(tuo01) AND l_ac > 1 THEN
             LET g_tuo[l_ac].* = g_tuo[l_ac-1].*
             NEXT FIELD tuo01
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
 
    CLOSE i226_bcl
    COMMIT WORK
 
END FUNCTION
 
#FUN-D40103 ------Begin------
FUNCTION i266_ime_chk(p_ime01,p_ime02)
   DEFINE  l_cnt        LIKE type_file.num5
   DEFINE  l_imeacti    LIKE ime_file.imeacti
   DEFINE  p_ime01      LIKE ime_file.ime01
   DEFINE  p_ime02      LIKE ime_file.ime02
   DEFINE  l_ime02      LIKE ime_file.ime02     #TQC-D50116
  #IF p_ime02 IS NOT NULL THEN    #TQC-D50127 mark
   IF p_ime02 IS NOT NULL AND p_ime02 != ' ' THEN #TQC-D50116
      SELECT COUNT(*) INTO l_cnt
        FROM ime_file
       WHERE ime01=p_ime01
         AND ime02=p_ime02
         AND ime05='Y'
      IF l_cnt = 0 THEN
      #  CALL cl_err('','mfg0095',0)                       #TQC-D50116
         CALL cl_err(p_ime01||' '||p_ime02,'mfg0095',0)    #TQC-D50116
         RETURN FALSE
      END IF 
   END IF    #TQC-D50116
   IF p_ime02 IS NOT NULL THEN   #TQC-D50127 
      LET l_imeacti = ''
      SELECT imeacti INTO l_imeacti FROM ime_file
       WHERE ime01=p_ime01
         AND ime02=p_ime02
      IF l_imeacti = 'N' THEN
      #  CALL cl_err('','aim-507',0)                       #TQC-D50116 
      #TQC-D50116 -----Begin----
         LET l_ime02 = p_ime02
         IF cl_null(l_ime02) THEN
            LET l_ime02 = "' '"
         END IF
         CALL cl_err_msg("","aim-507",p_ime01 || "|" || l_ime02 ,0) 
      #TQC-D50116 -----End------
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40103 ------End--------
FUNCTION i226_b_askkey()
    CLEAR FORM
    CALL g_tuo.clear()
    CONSTRUCT g_wc2 ON tuo01,tuo02,tuo03,tuo031,tuo04,tuo05
                  FROM s_tuo[1].tuo01,s_tuo[1].tuo02,s_tuo[1].tuo03,
                       s_tuo[1].tuo031,s_tuo[1].tuo04,s_tuo[1].tuo05
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(tuo01)   #客戶編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_occ"
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tuo01
                  NEXT FIELD tuo01
             WHEN INFIELD(tuo02)   #送貨客戶
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ'
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tuo02
                  NEXT FIELD tuo02
             WHEN INFIELD(tuo03)   #預設出貨倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd1"
                  LET g_qryparam.state    ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tuo03
                  NEXT FIELD tuo03
             WHEN INFIELD(tuo031)   #預設出貨儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ime"
                  LET g_qryparam.state    ="c"
                  LET g_qryparam.arg1     = g_tuo[l_ac].tuo03
                  LET g_qryparam.arg2     = 'SW'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tuo031
                  NEXT FIELD tuo031
             WHEN INFIELD(tuo04)   #預設寄銷倉庫
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imd01"
                  LET g_qryparam.state    ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tuo04
                  NEXT FIELD tuo04
             WHEN INFIELD(tuo05)   #預設寄銷儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ime"
                  LET g_qryparam.state    ="c"
                  LET g_qryparam.arg1     = g_tuo[l_ac].tuo04
                  LET g_qryparam.arg2     = 'SW'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tuo05
                  NEXT FIELD tuo05
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
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i226_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i226_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2        LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql = "SELECT tuo01,a.occ02,tuo02,b.occ02,tuo03,tuo031,tuo04,tuo05 ",
                "  FROM tuo_file,occ_file a,occ_file b ",
                " WHERE ", p_wc2 CLIPPED,
                "   AND tuo01 = a.occ01 ",
                "   AND tuo02 = b.occ01 ",
                " ORDER BY tuo01"
    PREPARE i226_pb FROM g_sql
    DECLARE tuo_curs CURSOR FOR i226_pb
 
    CALL g_tuo.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH tuo_curs INTO g_tuo[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH 
       END IF
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tuo.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
   #DISPLAY g_rec_b TO FORMONLY.cn2  #TQC-920064
    DISPLAY g_rec_b TO FORMONLY.cnt  #TQC-920064 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i226_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tuo TO s_tuo.* ATTRIBUTE(COUNT=g_rec_b)
 
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
#No.FUN-7C0043--start--
FUNCTION i226_out()
 DEFINE  sr              RECORD 
                         tuo01     LIKE tuo_file.tuo01,  
                         tuo01_ds  LIKE occ_file.occ02,  
                         tuo02     LIKE tuo_file.tuo02,
                         tuo02_ds  LIKE occ_file.occ02,  
                         tuo03     LIKE tuo_file.tuo03,  
                         tuo031    LIKE tuo_file.tuo031,  
                         tuo04     LIKE tuo_file.tuo04,  
                         tuo05     LIKE tuo_file.tuo05  
                        END RECORD,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)
 DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                    
                                                                                                                                    
    IF g_wc2 IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "axmi226" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN        
#   IF g_wc2 IS NULL THEN 
#      CALL cl_err('','9057',0) RETURN 
#   END IF
 
#   CALL cl_wait()
 
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#   # 組合出 SQL 指令
#   LET g_sql="SELECT tuo01,a.occ02,tuo02,b.occ02,tuo03,tuo031,tuo04,tuo05 ",
#             "  FROM tuo_file,occ_file a,occ_file b ",
#             " WHERE ",g_wc2 CLIPPED,
#             "   AND tuo01 = a.occ01 ",
#             "   AND tuo02 = b.occ01 "
#   PREPARE i226_p1 FROM g_sql              # RUNTIME 編譯
#   DECLARE i226_co CURSOR FOR i226_p1      # CURSOR
 
#   LET g_rlang = g_lang
#   CALL cl_outnam('axmi226') RETURNING l_name
 
#   START REPORT i226_rep TO l_name
 
#   FOREACH i226_co INTO sr.*
#      IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#      END IF
#      OUTPUT TO REPORT i226_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i226_rep
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
#REPORT i226_rep(sr)
#DEFINE l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680137  VARCHAR(1)
#      sr              RECORD 
#                       tuo01     LIKE tuo_file.tuo01,  
#                       tuo01_ds  LIKE occ_file.occ02,  
#                       tuo02     LIKE tuo_file.tuo02,
#                       tuo02_ds  LIKE occ_file.occ02,  
#                       tuo03     LIKE tuo_file.tuo03,  
#                       tuo031    LIKE tuo_file.tuo031,  
#                       tuo04     LIKE tuo_file.tuo04,  
#                       tuo05     LIKE tuo_file.tuo05  
#                      END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#  ORDER BY sr.tuo01
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<','/pageno'
#        PRINT g_head CLIPPED, pageno_total
#        #PRINT ''    #No.TQC-6A0091
#        PRINT g_dash[1,g_len] 
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#        PRINT g_dash1
#        LET l_trailer_sw = 'y'
 
#     ON EVERY ROW
#        PRINT COLUMN g_c[31],sr.tuo01,
#              COLUMN g_c[32],sr.tuo01_ds[1,15] CLIPPED,    #No.TQC-6A0091
#              COLUMN g_c[33],sr.tuo02,
#              COLUMN g_c[34],sr.tuo02_ds[1,15] CLIPPED,    #No.TQC-6A0091
#              COLUMN g_c[35],sr.tuo03,
#              COLUMN g_c[36],sr.tuo031,
#              COLUMN g_c[37],sr.tuo04,
#              COLUMN g_c[38],sr.tuo05
 
#     ON LAST ROW
#        PRINT g_dash[1,g_len] 
#        PRINT g_x[4] CLIPPED, COLUMN (g_len-7), g_x[7] CLIPPED
#        LET l_trailer_sw = 'n'
 
#     PAGE TRAILER
#        IF l_trailer_sw = 'y' THEN
#           PRINT g_dash[1,g_len] 
#           PRINT g_x[4] CLIPPED, COLUMN (g_len-7), g_x[6] CLIPPED
#        ELSE
#            SKIP 2 LINE
#         END IF
#END REPORT
#No.FUN-7C0043--end--
FUNCTION i226_set_entry_b(p_cmd)                                                                                                    
   DEFINE p_cmd   LIKE type_file.chr1                   #No.FUN-680137 VARCHAR(1)
                                                                                                                                     
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
      CALL cl_set_comp_entry("tuo01,tuo02",TRUE)                                                                                           
   END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i226_set_no_entry_b(p_cmd)                                                                                                 
   DEFINE p_cmd   LIKE type_file.chr1                  #No.FUN-680137 VARCHAR(1)
                                                                                                                                     
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
      CALL cl_set_comp_entry("tuo01,tuo02",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
