# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi5551.4gl
# Descriptions...: 会员积分/折扣规则排除明细档
# Date & Author..: No.FUN-960058 09/11/03 By destiny
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-A80022 10/10/28 By shiwuying 增加已傳POS否的邏輯
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/10 By huangtao 增加料號控管
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B70075 11/10/26 By nanbing 更新已傳POS否的狀態
# Modify.........: No.FUN-C40084 12/04/28 By baogc 添加有效碼欄位
# Modify.........: No.FUN-C40109 12/05/08 By baogc 添加生效日期(lrr03)和失效日期(lrr04)字段
# Modify.........: No.FUN-C60056 12/06/28 By Lori 變更傳入的參數與KEY值
# Modify.........: No.FUN-C70003 12/07/05 By Lori 卡管理-卡積分、折扣、儲值加值規則功能優化
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-960058--begin
DEFINE 
     g_lrr           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        lrr02       LIKE lrr_file.lrr02,   
        lrr02_1     LIKE ima_file.ima02,  #FUN-C40084 Add ,
        lrracti     LIKE lrr_file.lrracti #FUN-C40084 Add
                    END RECORD,
     g_lrr_t         RECORD                    #程式變數 (舊值)
        lrr02       LIKE lrr_file.lrr02,   
        lrr02_1     LIKE ima_file.ima02,  #FUN-C40084 Add ,
        lrracti     LIKE lrr_file.lrracti #FUN-C40084 Add
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,         
    g_rec_b         LIKE type_file.num5,                #單身筆數     
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
#DEFINE g_argv1      LIKE lrr_file.lrr00     #FUN-C60056 mark
#DEFINE g_argv2      LIKE lrr_file.lrr01     #FUN-C60056 mark
#DEFINE g_argv3      LIKE lrr_file.lrr03     #FUN-C60056 mark   #FUN-C40109 ADD
#DEFINE g_argv4      LIKE lrr_file.lrr04     #FUN-C60056 mark   #FUN-C40109 ADD
DEFINE g_argv1      LIKE lrp_file.lrp06      #FUN-C60056 add
DEFINE g_argv2      LIKE lrp_file.lrp07      #FUN-C60056 add
DEFINE g_argv3      LIKE lrp_file.lrp08      #FUN-C60056 add
DEFINE g_argv4      LIKE lrp_file.lrpplant   #FUN-C60056 add 
#DEFINE g_lrp03      LIKE lrp_file.lrp03     #FUN-C60056 mark
DEFINE g_forupd_sql STRING    
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-9B0136 
DEFINE g_i          LIKE type_file.num5      
DEFINE g_before_input_done   LIKE type_file.num5     
DEFINE g_lrp_1      RECORD LIKE lrp_file.*  #FUN-C40109 Add 鎖資料
DEFINE g_lrp        RECORD LIKE lrp_file.*  #FUN-C60056 add

MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4)
        
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    

  #FUN-C40109 Add Begin ---
  #LET g_forupd_sql = "SELECT * FROM lrp_file WHERE lrp00= ? AND lrp01 = ? AND lrp04 = ? AND lrp05 = ? FOR UPDATE "          #FUN-C60056 mark
   LET g_forupd_sql = "SELECT * FROM lrp_file WHERE lrp06 = ? AND lrp07 = ? AND lrp08 = ? AND lrpplant = ? FOR UPDATE "      #FUN-C60056 add
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE i5551_cl CURSOR FROM g_forupd_sql
  #FUN-C40109 Add End -----

   OPEN WINDOW i5551_w WITH FORM "alm/42f/almi5551"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

  #FUN-C40109 Mark&Add Begin --- 
  #IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
  #   LET g_wc2 = "lrr00 = '",g_argv1,"' and lrr01 = '",g_argv2,"'"                   
  #END IF  

  #SELECT lrp03 INTO g_lrp03 FROM lrp_file WHERE lrp00=g_argv1 AND lrp01=g_argv2

  #FUN-C60056 mark begin---
  #IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND
  #   NOT cl_null(g_argv3) AND NOT cl_null(g_argv4) THEN
  #   LET g_wc2 = " lrr00 = '",g_argv1,"' AND lrr01 = '",g_argv2,"' AND ",
  #               " lrr03 = '",g_argv3,"' AND lrr04 = '",g_argv4,"' "
  #END IF
  #FUN-C60056 mark end-----

  #FUN-C60056 add begin---
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv4) THEN
   LET g_wc2 = " lrr05 = '",g_argv1,"' AND lrr06 = '",g_argv2,"' AND lrrplant = '",g_argv4,"' "
   END IF
  #FUN-C60056 add end-----

  #SELECT lrp03 INTO g_lrp03                                                                  #FUN-C60056 mark
  #  FROM lrp_file                                                                            #FUN-C60056 mark
  # WHERE lrp00 = g_argv1 AND lrp01 = g_argv2 AND lrp04 = g_argv3 AND lrp05 = g_argv4         #FUN-C60056 mark
  #FUN-C40109 Mark&Add End -----

   SELECT * INTO g_lrp.* FROM lrp_file WHERE lrp06 = g_argv1 AND lrp07 = g_argv2 AND lrp08 = g_argv3 AND lrpplant = g_argv4   #FUN-C60056 add   

   #FUN-C70003 add begin---
   IF g_plant <> g_argv4 THEN
      CALL cl_set_comp_entry("lrr02,lrracti",FALSE)         
   ELSE
      CALL cl_set_comp_entry("lrr02,lrracti",TRUE)          
   END IF
   #FUN-C70003 add end-----

   CALL i5551_b_fill(g_wc2)
   CALL i5551_menu()
   CLOSE WINDOW i5551_w                    #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
      RETURNING g_time    
END MAIN

FUNCTION i5551_b_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000

   #FUN-C40109 Mark&Add Begin ---
   #IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
   #   LET p_wc2 = "lrr00 = '",g_argv1,"' and lrr01 = '",g_argv2,"'"                   
   #END IF  

   #FUN-C60056 mark begin---
   #IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND
   #   NOT cl_null(g_argv3) AND NOT cl_null(g_argv4) THEN
   #   LET p_wc2 = " lrr00 = '",g_argv1,"' AND lrr01 = '",g_argv2,"' AND ",
   #               " lrr03 = '",g_argv3,"' AND lrr04 = '",g_argv4,"' "
   #END IF
   #FUN-C60056 mark end-----
   #FUN-C40109 Mark&Add End -----
    
   #FUN-C60056 add begin---
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv4) THEN
       LET p_wc2 = " lrr05 = '",g_argv1,"' AND lrr06 = '",g_argv2,"' AND  lrrplant = '",g_argv4,"' "
    END IF
   #FUN-C60056 add end-----

   #LET g_sql = "SELECT lrr02,'' ",         #FUN-C40084 Mark
    LET g_sql = "SELECT lrr02,'',lrracti ", #FUN-C40084 Add
                 " FROM lrr_file ",
                 " WHERE ", p_wc2 CLIPPED,        #單身
                 " ORDER BY lrr02 "
    PREPARE i5551_pb FROM g_sql
    DECLARE lrr_curs CURSOR FOR i5551_pb

    CALL g_lrr.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lrr_curs INTO g_lrr[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CASE g_lrp.lrp03                              #g_lrp03  #FUN-C60056 g_lrp03 change to g_lrp.lrp03
           WHEN "2"
              SELECT ima02 INTO g_lrr[g_cnt].lrr02_1 FROM ima_file
               WHERE ima01=g_lrr[g_cnt].lrr02
           WHEN "3"
              SELECT oba02 INTO g_lrr[g_cnt].lrr02_1 FROM oba_file
               WHERE oba01=g_lrr[g_cnt].lrr02
        END CASE 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lrr.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION 

FUNCTION i5551_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i5551_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i5551_q()
            END IF      
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i5551_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lrr),'','')
            END IF         
      END CASE
   END WHILE
END FUNCTION

FUNCTION i5551_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,                #檢查重複用 
   l_n2            LIKE type_file.num5,      
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1                 #可刪除否
DEFINE     l_imaacti     LIKE ima_file.imaacti
DEFINE     l_ima02       LIKE ima_file.ima02
DEFINE     l_obaacti     LIKE oba_file.obaacti
DEFINE     l_oba02       LIKE oba_file.oba02
DEFINE     l_flg         LIKE type_file.chr1   #No.FUN-A80022
DEFINE     l_lrppos      LIKE lrp_file.lrppos  #NO.FUN-B40071
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
  #IF cl_null(g_argv1) OR cl_null(g_argv2) THEN  #FUN-C40109 MARK

   IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) OR cl_null(g_argv4) THEN #FUN-C40109 ADD
      CALL cl_err('','alm-815',1)
      RETURN 
   END IF 

   #FUN-C70003 add begin---
   IF g_lrp.lrp09 = 'Y' THEN
      CALL cl_err('','alm-h55',0)  #F已發佈,不可修改
      RETURN
   END IF

   IF g_lrp.lrpconf = 'Y' THEN     #已確認時不允許修改
      CALL cl_err('','alm-027',0)
      RETURN
   END IF

   IF g_lrp.lrpacti = 'N' THEN   #資料無效不允許修改
      CALL cl_err('','alm-069',0)
      RETURN
   END IF
   #FUN-C70003 add end-----

   #FUN-B70075 Begin---
   IF g_aza.aza88 = 'Y' THEN
     #FUN-C40109 Add Begin ---
      BEGIN WORK
      OPEN i5551_cl USING g_argv1,g_argv2,g_argv3,g_argv4
      IF STATUS THEN
         CALL cl_err("OPEN i555_cl:", STATUS, 1)
         CLOSE i5551_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i5551_cl INTO g_lrp_1.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lrp_1.lrp01,SQLCA.sqlcode,0)
         CLOSE i5551_cl
         ROLLBACK WORK
         RETURN
      END IF
     #FUN-C40109 Add End -----
      LET l_flg = 'N'
      
      #FUN-C60056 mark begin---
      #SELECT lrppos INTO l_lrppos FROM lrp_file
      # WHERE lrp00 = g_argv1 AND lrp01 = g_argv2
      #   AND lrp04 = g_argv3 AND lrp05 = g_argv4 #FUN-C40109 ADD
      #UPDATE lrp_file SET lrppos = '4'
      # WHERE lrp00 = g_argv1 AND lrp01 = g_argv2
      #   AND lrp04 = g_argv3 AND lrp05 = g_argv4 #FUN-C40109 ADD
      #FUN-C60056 mark end-----
 
      #FUN-C60056 add begin---
       SELECT lrppos INTO l_lrppos FROM lrp_file WHERE lrp06 = g_argv1 AND lrp07 = g_argv2 AND lrp08 = g_argv3 AND lrpplant = g_argv4
       
       UPDATE lrp_file SET lrppos = '4' WHERE lrp06= g_argv1 AND lrp07 = g_argv2 AND lrp08 = g_argv3 AND lrpplant = g_argv4  
      #FUN-C60056 add end-----
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lrp_file",g_argv2,"",SQLCA.sqlcode,"","",1)
         RETURN 
      END IF
      COMMIT WORK  #FUN-C40109 Add
   END IF
  ##FUN-B70075 End---
  #LET l_flg = 'N' #No.FUN-A80022

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

  #LET g_forupd_sql = "SELECT lrr02,'' ",         #FUN-C40084 Mark
  #FUN-C40109 Mark&Add Begin ---
  #LET g_forupd_sql = "SELECT lrr02,'',lrracti ", #FUN-C40084 Add
  #                   "  FROM lrr_file WHERE lrr00='",g_argv1,"' ",
  #                   "  and lrr01='",g_argv2,"' and lrr02 = ?  FOR UPDATE "

  #FUN-C60056 mark begin---
  #LET g_forupd_sql = "SELECT lrr02,'',lrracti ",
  #                   "  FROM lrr_file ",
  #                   " WHERE lrr00 = '",g_argv1,"' AND lrr01 = '",g_argv2,"' ",
  #                   "   AND lrr03 = '",g_argv3,"' AND lrr04 = '",g_argv4,"' ",
  #                   "   AND lrr02 = ?  FOR UPDATE "
  #FUN-C60056 mark end-----
  #FUN-C40109 Mark&Add End -----

   #FUN-C60056 add begin---
   LET g_forupd_sql = "SELECT lrr02,'',lrracti FROM lrr_file ",
                      " WHERE lrr05 = '",g_argv1,"' AND lrr06 = '",g_argv2,"' ",
                      "   AND lrrplant = '",g_argv4,"' AND lrr02 = ?  FOR UPDATE "
   #FUN-C60056 add end-----

   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

   DECLARE i5551_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_lrr WITHOUT DEFAULTS FROM s_lrr.*
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

         #FUN-C40109 Add Begin ---
          BEGIN WORK
          OPEN i5551_cl USING g_argv1,g_argv2,g_argv3,g_argv4  
          IF STATUS THEN
             CALL cl_err("OPEN i555_cl:", STATUS, 1)
             CLOSE i5551_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i5551_cl INTO g_lrp_1.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_lrp_1.lrp01,SQLCA.sqlcode,0)
             CLOSE i5551_cl
             ROLLBACK WORK
             RETURN
          END IF
         #FUN-C40109 Add End -----

          IF g_rec_b>=l_ac THEN 
            #BEGIN WORK      #FUN-C40109 Mark
             LET p_cmd='u'                                                
             LET g_before_input_done = FALSE                                    
#             CALL i5551_set_entry(p_cmd)                                         
#             CALL i5551_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                             
             LET g_lrr_t.* = g_lrr[l_ac].*  #BACKUP
             OPEN i5551_bcl USING g_lrr_t.lrr02
             IF STATUS THEN
                CALL cl_err("OPEN i5551_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i5551_bcl INTO g_lrr[l_ac].* 
                CALL i5551_lrr02('d')
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lrr_t.lrr02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF

       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
#          CALL i5551_set_entry(p_cmd)                                            
#          CALL i5551_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lrr[l_ac].* TO NULL       
          LET g_lrr[l_ac].lrracti = 'Y'  #FUN-C40084 Add
          LET g_lrr_t.* = g_lrr[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD lrr02

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i5551_bcl
             CANCEL INSERT
          END IF
        #FUN-C40109 Mark Begin ---
        ##FUN-C40084 Mark&Add Begin ---
        ##INSERT INTO lrr_file(lrr00,lrr01,lrr02)
        ##  VALUES(g_argv1,g_argv2,g_lrr[l_ac].lrr02)

        # INSERT INTO lrr_file(lrr00,lrr01,lrr02,lrracti)
        #   VALUES(g_argv1,g_argv2,g_lrr[l_ac].lrr02,g_lrr[l_ac].lrracti)
        ##FUN-C40084 Mark&Add End -----
        #FUN-C40109 Mark End -----

         #FUN-C40109 Add Begin ---
          INSERT INTO lrr_file(lrr00,lrr01,lrr02,lrr03,lrr04,lrracti,lrr05,lrr06,lrrlegal,lrrplant)        #FUN-C60056 add lrr05,lrr06,lrrlegal,lrrplant
                        VALUES(g_lrp.lrp00,g_lrp.lrp01,g_lrr[l_ac].lrr02,g_lrp.lrp04,g_lrp.lrp05,g_lrr[l_ac].lrracti,g_argv1,g_argv2,g_lrp.lrplegal,g_argv4)   #FUN-C60056 add 
           #VALUES(g_argv1,g_argv2,g_lrr[l_ac].lrr02,g_argv3,g_argv4,g_lrr[l_ac].lrracti)   #FUN-C60056 mark
         #FUN-C40109 Add End -----
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lrr_file",g_lrr[l_ac].lrr02,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
            #FUN-C40109 Add End -----
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
             LET l_flg = 'Y' #No.FUN-A80022
            #FUN-C40109 Add Begin ---
             IF l_lrppos <> '1' THEN
                LET l_lrppos = '2'
             ELSE
                LET l_lrppos = '1'
             END IF
            #FUN-C40109 Add End -----
          END IF
           
       AFTER FIELD lrr02
         IF NOT cl_null(g_lrr[l_ac].lrr02) THEN
            #FUN-AB0025 ---------------------start----------------------------
            IF g_lrp.lrp03 = '2' THEN                                        #IF g_lrp03='2' THEN    #FUN-C60056 g_lrp03 change to g_lrp.lrp03
               IF NOT s_chk_item_no(g_lrr[l_ac].lrr02,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_lrr[l_ac].lrr02= g_lrr_t.lrr02
                  NEXT FIELD lrr02
               END IF
            END IF
            #FUN-AB0025 ---------------------end-------------------------------
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lrr[l_ac].lrr02 != g_lrr_t.lrr02) THEN
               CALL i5551_lrr02('a')
               IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,1)
                  LET g_lrr[l_ac].lrr02=g_lrr_t.lrr02
                  NEXT FIELD lrr02
               END IF 
               
               #FUN-C60056 mark begin---                 
               #SELECT COUNT(*) INTO l_n2 FROM lrr_file
               # WHERE lrr00 = g_argv1
               #   AND lrr01 = g_argv2
               #   AND lrr03 = g_argv3 #FUN-C40109 ADD
               #   AND lrr04 = g_argv4 #FUN-C40109 ADD
               #   AND lrr02=g_lrr[l_ac].lrr02
               #FUN-C60056 mark end-----

               #FUN-C60056 add begin---
                SELECT COUNT(*) INTO l_n2 FROM lrr_file
                 WHERE lrr05 = g_argv1
                   AND lrr06 = g_argv2
                   AND lrrplant = g_argv4
                   AND lrr02=g_lrr[l_ac].lrr02
               #FUN-C60056 add end-----

               IF l_n2>0 THEN 
                  CALL cl_err('','-239',1)
                  LET g_lrr[l_ac].lrr02=NULL
                  NEXT FIELD lrr02
               END IF 
           END IF 
       END IF
                               		
       BEFORE DELETE                            #是否取消單身
          IF g_lrr_t.lrr02 IS NOT NULL THEN
            #FUN-C40084 Add Begin ---
             IF g_aza.aza88 = 'Y' THEN
                IF l_lrppos = '1' OR (l_lrppos = '3' AND g_lrr_t.lrracti = 'N') THEN
                ELSE
                   CALL cl_err('','apc-155',0) #資料狀態已傳POS否為1.新增未下傳,或已傳POS否為3.已下傳且資料有效否為'N',才可刪除!
                   CANCEL DELETE
                END IF
             END IF
            #FUN-C40084 Add End -----
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 

             #FUN-C60056 mark begin---
             #DELETE FROM lrr_file WHERE lrr00 = g_argv1 AND lrr01 = g_argv2 
             #                       AND lrr02 = g_lrr_t.lrr02 
             #                       AND lrr03 = g_argv3 AND lrr04 = g_argv4 #FUN-C40109 ADD
             #FUN-C60056 markend---

             #FUN-C60056 add begin---
             DELETE FROM lrr_file WHERE lrr05 = g_argv1 AND lrr06 = g_argv2 AND lrrplant = g_argv4 
                                    AND lrr02 = g_lrr_t.lrr02
             #FUN-C60056 add end---

             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lrr_file",g_lrr_t.lrr02,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
            #LET l_flg = 'Y' #No.FUN-A80022 #FUN-C40109 Mark
          END IF

       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lrr[l_ac].* = g_lrr_t.*
             CLOSE i5551_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF

          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lrr[l_ac].lrr02,-263,0)
             LET g_lrr[l_ac].* = g_lrr_t.*
          ELSE
            #UPDATE lrr_file SET lrr02=g_lrr[l_ac].lrr02                           #FUN-C40084 Mark
            #FUN-C60056 mark begin---
            # UPDATE lrr_file SET lrr02=g_lrr[l_ac].lrr02,lrracti=g_lrr[l_ac].lrracti #FUN-C40084 Add
            #  WHERE lrr00 = g_argv1
            #    AND lrr01 = g_argv2
            #    AND lrr02 = g_lrr_t.lrr02
            #    AND lrr03 = g_argv3 #FUN-C40109 ADD
            #   #AND lrr04 = g_argv4 #FUN-C40109 ADD   #FUN-C60056 mark
            #FUN-C60056 mark end-----

            #FUN-C60056 add begin---
             UPDATE lrr_file SET lrr02=g_lrr[l_ac].lrr02,lrracti=g_lrr[l_ac].lrracti 
              WHERE lrr05 = g_argv1 AND lrr06 = g_argv2  AND lrrplant = g_argv4 
                AND lrr02 = g_lrr_t.lrr02
            #FUN-C60056 add end-----
    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lrr_file",g_lrr_t.lrr02,"",SQLCA.sqlcode,"","",1) 
                LET g_lrr[l_ac].* = g_lrr_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
                LET l_flg = 'Y' #No.FUN-A80022
               #FUN-C40109 Add Begin ---
                IF l_lrppos <> '1' THEN
                   LET l_lrppos = '2'
                ELSE
                   LET l_lrppos = '1'
                END IF
               #FUN-C40109 Add End -----
             END IF
          END IF

       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增   #FUN-D30033 Mark

          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lrr[l_ac].* = g_lrr_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lrr.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE i5551_bcl            # 新增
             ROLLBACK WORK              # 新增
             EXIT INPUT
          END IF

          LET l_ac_t = l_ac             #FUN-D30033 Add 
          CLOSE i5551_bcl               # 新增
          COMMIT WORK

          
      ON ACTION controlp
         CASE
            WHEN INFIELD(lrr02)    
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  CASE g_lrp03
             #     WHEN "2"
             #       LET g_qryparam.form ="q_ima"
             #     WHEN "3"
             #       LET g_qryparam.form ="q_oba1"
             #  END CASE  
             #  LET g_qryparam.default1 = g_lrr[l_ac].lrr02
             #  CALL cl_create_qry() RETURNING g_lrr[l_ac].lrr02
               CASE g_lrp.lrp03                                            #g_lrp03  #FUN-C60056 g_lrp03 chenge to g_lrp.lrp03
                  WHEN "2"
                     CALL q_sel_ima(FALSE, "q_ima", "", g_lrr[l_ac].lrr02, "", "", "", "" ,"",'' )  RETURNING g_lrr[l_ac].lrr02
                  WHEN "3"
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_oba1"
                     LET g_qryparam.default1 = g_lrr[l_ac].lrr02
                     CALL cl_create_qry() RETURNING g_lrr[l_ac].lrr02
               END CASE
#FUN-AA0059 --End--
               DISPLAY g_lrr[l_ac].lrr02 TO lrr02 
               NEXT FIELD lrr02
            OTHERWISE EXIT CASE
          END CASE    
                  
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lrr02) AND l_ac > 1 THEN
             LET g_lrr[l_ac].* = g_lrr[l_ac-1].*
             NEXT FIELD lrr02
          END IF

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
          

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       
   END INPUT

   CLOSE i5551_cl   #FUN-C40109 Add
   CLOSE i5551_bcl
   COMMIT WORK
  #No.FUN-A80022 Begin---
  #FUN-B70075 Mark Begin --------
  # IF g_aza.aza88 = 'Y' AND l_flg = 'Y' THEN
     #FUN-B40071 --START--     
      #UPDATE lrp_file SET lrppos = 'N'
      # WHERE lrp00 = g_argv1 AND lrp01 = g_argv2
  #    SELECT lrppos INTO l_lrppos FROM lrp_file
  #     WHERE lrp00 = g_argv1 AND lrp01 = g_argv2
  #    IF l_lrppos <> '1' THEN
  #       LET l_lrppos = '2'
  #    ELSE
  #       LET l_lrppos = '1'
  #    END IF
  #    UPDATE lrp_file SET lrppos = l_lrppos
  #     WHERE lrp00 = g_argv1 AND lrp01 = g_argv2
     #FUN-B40071 --END--
  # END IF
  #FUN-B70075 Mark End --------
  #No.FUN-A80022 End-----
  #FUN-B70075 Begin -------  
   IF g_aza.aza88 = 'Y' THEN
      IF l_flg = 'Y' THEN
         IF l_lrppos <> '1' THEN
            LET l_lrppos = '2'
         ELSE
             LET l_lrppos = '1'
         END IF

         #FUN-C60056 mark begin---
         #UPDATE lrp_file SET lrppos = l_lrppos
         # WHERE lrp00 = g_argv1 AND lrp01 = g_argv2
         #   AND lrp04 = g_argv3 AND lrp05 = g_argv4 #FUN-C40109 ADD
         #FUN-C6005r mark end-----

         #FUN-C60056 add begin---
          UPDATE lrp_file SET lrppos = l_lrppos WHERE lrp06 = g_argv1 AND lrp07= g_argv2 AND lrp08 =g_argv3 AND lrpplant = g_argv4 
         #FUN-C60056 add end-----

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lrp_file",g_argv2,"",SQLCA.sqlcode,"","",1)
            RETURN
         END IF
      ELSE
         #FUN-C60056 mark begin---
         #UPDATE lrp_file SET lrppos = l_lrppos
         # WHERE lrp00 = g_argv1 AND lrp01 = g_argv2
         #   AND lrp04 = g_argv3 AND lrp05 = g_argv4 #FUN-C40109 ADD
         #FUN-C6005r mark end-----

         #FUN-C60056 add begin---
          UPDATE lrp_file SET lrppos = l_lrppos WHERE lrp06 = g_argv1 AND lrp07= g_argv2 AND lrp08 = g_argv3 AND lrpplant = g_argv4
         #FUN-C60056 add end-----

         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lrp_file",g_argv2,"",SQLCA.sqlcode,"","",1)
            RETURN
         END IF
      END IF
   END IF
  #FUN-B70075 End ----------  
END FUNCTION

FUNCTION i5551_lrr02(p_cmd)
DEFINE     p_cmd         LIKE type_file.chr1
DEFINE     l_imaacti     LIKE ima_file.imaacti
DEFINE     l_ima02       LIKE ima_file.ima02
DEFINE     l_obaacti     LIKE oba_file.obaacti
DEFINE     l_oba02       LIKE oba_file.oba02

   CASE g_lrp.lrp03                            #g_lrp03  #FUN-C60056 g_lrp03 chenge to g_lrp.lgrp03
      WHEN "2"
          SELECT imaacti,ima02 INTO l_imaacti,l_ima02 FROM ima_file 
          WHERE ima01=g_lrr[l_ac].lrr02
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_ima02 = NULL
               WHEN l_imaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END CASE                
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_lrr[l_ac].lrr02_1=l_ima02
             DISPLAY BY NAME g_lrr[l_ac].lrr02_1
          END IF               
      WHEN "3"
          SELECT obaacti,oba02 INTO l_obaacti,l_oba02
             FROM oba_file
            WHERE oba01=g_lrr[l_ac].lrr02
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_oba02 = NULL
               WHEN l_obaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case              
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_lrr[l_ac].lrr02_1=l_oba02
             DISPLAY BY NAME g_lrr[l_ac].lrr02_1
          END IF                                                        
   END CASE    
END FUNCTION                 
FUNCTION i5551_q()
   CALL i5551_b_askkey()
END FUNCTION

FUNCTION i5551_b_askkey()

   CLEAR FORM
   CALL g_lrr.clear()
  #FUN-C40084 Mark&Add Begin ---
  #CONSTRUCT g_wc2 ON lrr02
  #     FROM s_lrr[1].lrr02

   CONSTRUCT g_wc2 ON lrr02,lrracti FROM s_lrr[1].lrr02,s_lrr[1].lrracti
  #FUN-C40084 Mark&Add End -----

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
                 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask() 
         
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(lrr02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lrr02"   
                 LET g_qryparam.arg1=g_argv1
                 LET g_qryparam.arg2=g_argv2
                #LET g_qryparam.arg3=g_argv3      #FUN-C40109 ADD
                #LET g_qryparam.arg4=g_argv4      #FUN-C60056 mark     #FUN-C40109 ADD
                 LET g_qryparam.arg3=g_argv4      #FUN-C60056 add
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO  lrr02
                 NEXT FIELD lrr02
           END CASE
           
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b =0
      RETURN
   END IF

   CALL i5551_b_fill(g_wc2)

END FUNCTION

FUNCTION i5551_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 CHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lrr TO s_lrr.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   

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
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY


      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


                                                                       
