# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Modify ........: 03/04/28 By Kammy no.7168
# Description....: 選配件/備品維護程式
#
# 將選配件程式獨立成副程式，如此訂單與三角貿易訂單只須修改一個地方
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: 04/09/07 By Wiky Bugno.MOD-490053 訂單單身中，在產生「選擇配件資料維護」時，產生之選配件資料欄位會帶錯。Unit 上會帶出數字。
# Modify.........: #No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE  
# Modify.........: No.FUN-710037 07/01/18 By kim t400_oeo改為 s_t400oeo
# Modify.........: No.MOD-850132 08/05/13 By Smapmin 備品料號不可與訂單銷售料號相同. 
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70164 10/07/21 By Carrier 生成备料时,根据订单单身数量default oeo09
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管 
# Modify.........: No.FUN-910088 11/11/16 By chenjing 增加數量欄位小數取位 
# Modify.........: No:MOD-BA0001 12/02/03 By Summer l_oeo[j].oeo09應為l_oeo[i].oeo09 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.MOD-A70164  --Begin                                                         
#FUNCTION s_t400oeo(p_no,p_seq,p_part) #FUN-710037                              
FUNCTION s_t400oeo(p_no,p_seq,p_part,p_qty)                                     
  DEFINE p_qty          LIKE oeb_file.oeb12                                     
#No.MOD-A70164  --End
  DEFINE ls_tmp         STRING
  DEFINE p_no           LIKE oea_file.oea01            #No.FUN-550070    # No.FUN-680137 VARCHAR(16)
  DEFINE p_seq          LIKE type_file.num5        # No.FUN-680137  SMALLINT  
   DEFINE p_part	        LIKE bmb_file.bmb01 #No.MOD-490217	
  DEFINE l_oeo		DYNAMIC ARRAY OF RECORD
         oeo04  LIKE oeo_file.oeo04,
         ima02  LIKE ima_file.ima02,
         oeo05  LIKE oeo_file.oeo05,
         oeo06  LIKE oeo_file.oeo06,
         oeo09  LIKE oeo_file.oeo09,
         oeo08  LIKE oeo_file.oeo08,
         oeo07  LIKE oeo_file.oeo07 
         END RECORD
  DEFINE l_oeo_t RECORD
         oeo04  LIKE oeo_file.oeo04,
         ima02  LIKE ima_file.ima02,
         oeo05  LIKE oeo_file.oeo05,
         oeo06  LIKE oeo_file.oeo06,
         oeo09  LIKE oeo_file.oeo09,
         oeo08  LIKE oeo_file.oeo08,
         oeo07  LIKE oeo_file.oeo07 
         END RECORD
  DEFINE l_oeo05_t LIKE oeo_file.oeo05    #FUN-910088--add
  DEFINE l_flag    LIKE type_file.chr1    #FUN-910088--add
  DEFINE l_oeb12             LIKE oeb_file.oeb12
  DEFINE l_i                 LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE p_row,p_col         LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE i,j,s,l_cnt         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
         l_allow_insert      LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
         l_allow_delete      LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   SELECT COUNT(*) INTO i FROM oeo_file
          WHERE oeo01 = p_no AND oeo03 = p_seq
   IF i = 0 THEN 
      IF cl_confirm('axm-192') THEN
         #BugNo:6088
         DROP TABLE x
         #取Feature件
         SELECT bmb03 x1,(bmb06/bmb07)*(1+bmb08/100) x2 FROM bmb_file,ima_file
                WHERE bmb01 = p_part AND bmb03=ima01 AND ima08='D'
                INTO TEMP x
         #取Option件
         DECLARE t400_b_oeo_c1 CURSOR FOR
               SELECT bmb03,'',bmb10,x2*(bmb06/bmb07)*(1+bmb08/100),0,'1',bmb14 #MOD-490053
                      FROM x, bmb_file
                     WHERE x1 = bmb01
         LET j=1
         FOREACH t400_b_oeo_c1 INTO l_oeo[j].*
            IF STATUS THEN EXIT FOREACH END IF
            MESSAGE l_oeo[j].oeo04
            #No.MOD-A70164  --Begin                                             
            LET l_oeo[j].oeo09 = p_qty * l_oeo[j].oeo06                         
            LET l_oeo[j].oeo09 = s_digqty(l_oeo[j].oeo09,l_oeo[j].oeo05)  #FUN-910088--add--
            #No.MOD-A70164  --End
            INSERT INTO oeo_file(oeo01,oeo03,oeo04,oeo05,oeo06,oeo07,
                                  oeo08,oeo09,   #No.MOD-470041 
                                 oeoplant,oeolegal)   #FUN-980010 add plant & legal 
                          VALUES(p_no,p_seq,l_oeo[j].oeo04,
                                 l_oeo[j].oeo05, l_oeo[j].oeo06,
                                 l_oeo[j].oeo07, l_oeo[j].oeo08, 
                                 l_oeo[j].oeo09, g_plant,g_legal)
         END FOREACH
      END IF 
   END IF
 
   LET p_row = 3 LET p_col = 10
   OPEN WINDOW t4006_w AT p_row,p_col WITH FORM "axm/42f/axmt4006"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmt4006")
       
   DISPLAY BY NAME p_no,p_seq,p_part
 
   DECLARE t4006_c CURSOR FOR
           SELECT oeo04,ima02,oeo05,oeo06,oeo09,oeo08,oeo07
             FROM oeo_file, OUTER ima_file
            WHERE oeo01 = p_no AND oeo03 = p_seq AND oeo_file.oeo04=ima_file.ima01
 
   CALL l_oeo.clear()
   LET i = 1
   LET l_i = 0
   FOREACH t4006_c INTO l_oeo[i].*
      IF STATUS THEN CALL cl_err('foreach oeo',STATUS,0) EXIT FOREACH END IF 
      LET i = i + 1
 
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   CALL l_oeo.deleteElement(i)
   LET l_i=i-1
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_oeo WITHOUT DEFAULTS FROM s_oeo.* 
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF l_i != 0 THEN
               CALL fgl_set_arr_curr(i)
            END IF
 
        BEFORE ROW
           LET i=ARR_CURR()
 
        BEFORE FIELD oeo04
           IF cl_null(l_oeo[i].oeo09) THEN 
              LET l_oeo[i].oeo09 = 0 
           END IF
           IF cl_null(l_oeo[i].oeo08) THEN 
              LET l_oeo[i].oeo08 = '1'
           END IF
           LET l_oeo_t.* = l_oeo[i].*   
 
        AFTER FIELD oeo04 
           IF NOT cl_null(l_oeo[i].oeo04) THEN 
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(l_oeo[i].oeo04,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET l_oeo[i].oeo04= l_oeo_t.oeo04
                 NEXT FIELD oeo04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              #-----MOD-850132---------
              IF l_oeo[i].oeo04 = p_part THEN
                 CALL cl_err('','axm-091',0)
                 NEXT FIELD oeo04
              END IF
              #-----END MOD-850132----- 
              SELECT ima02,ima31 INTO l_oeo[i].ima02,l_oeo[i].oeo05 FROM ima_file 
               WHERE ima01 = l_oeo[i].oeo04 AND imaacti = 'Y' 
              IF STATUS THEN 
#                CALL cl_err('oeo-ima',100,0)     #No.FUN-660167
                 CALL cl_err3("sel","ima_file",l_oeo[i].oeo04,"",100,"","oeo-ima",0)   #No.FUN-660167
                 LET l_oeo[i].oeo04 = l_oeo_t.oeo04 
                 LET l_oeo[i].ima02 = l_oeo_t.ima02 
                 NEXT FIELD oeo04 
              END IF 
           END IF 
 
        AFTER FIELD oeo05
           IF NOT cl_null(l_oeo[i].oeo05)  THEN
              SELECT COUNT(*) INTO l_cnt FROM gfe_file 
               WHERE gfe01 = l_oeo[i].oeo05  AND gfeacti='Y' 
              IF l_cnt = 0  THEN 
                 CALL cl_err('oeo-gfe',100,0)  
                 NEXT FIELD oeo05 
              END IF 
#FUN-910088--add--start--
              CALL t400_oeo09_check(p_no,p_seq,l_oeo[i].oeo09,l_oeo_t.oeo09,l_oeo[i].oeo05,l_oeo05_t,l_oeo[i].oeo06,i,j)
                   RETURNING l_flag,l_oeo[i].oeo06,l_oeo[i].oeo09
              IF NOT l_flag THEN
                 LET l_oeo05_t = l_oeo[i].oeo05
                 NEXT FIELD oeo09
              END IF
              LET l_oeo05_t = l_oeo[i].oeo05
#FUN-910088--add--end--
           END IF 

        AFTER FIELD oeo06
           IF NOT cl_null(l_oeo[i].oeo06) THEN 
              IF l_oeo[i].oeo06 > 0 THEN
                 SELECT oeb12 INTO l_oeb12 FROM oeb_file
                  WHERE oeb01 = p_no AND oeb03 = p_seq
                 IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
                 LET l_oeo[i].oeo09 = l_oeo[i].oeo06 * l_oeb12
                 LET l_oeo[i].oeo09 = s_digqty(l_oeo[i].oeo09,l_oeo[i].oeo05)  #FUN-910088--add--
                 DISPLAY l_oeo[i].oeo09 TO s_oeo[j].oeo09
              END IF
           END IF
 
        AFTER FIELD oeo09
         #FUN-910088--add--start
           CALL t400_oeo09_check(p_no,p_seq,l_oeo[i].oeo09,l_oeo_t.oeo09,l_oeo[i].oeo05,l_oeo05_t,l_oeo[i].oeo06,i,j)
                RETURNING l_flag,l_oeo[i].oeo06,l_oeo[i].oeo09
           IF NOT l_flag THEN
              NEXT FIELD oeo09
           END IF 
         #FUN-910088--add--end--
         #FUN-910088--mark--start--
         # IF NOT cl_null(l_oeo[i].oeo09) THEN 
         #    IF l_oeo[i].oeo09 < 0 THEN
         #       NEXT FIELD oeo09
         #    END IF 
         #    SELECT oeb12 INTO l_oeb12 FROM oeb_file
         #     WHERE oeb01 = p_no AND oeb03 = p_seq
         #    IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
         #    IF l_oeb12 !=0 THEN  
         #       LET l_oeo[i].oeo06 = l_oeo[i].oeo09 / l_oeb12
         #       DISPLAY l_oeo[i].oeo06 TO s_oeo[j].oeo06
         #    END IF
         # END IF
         #FUN-910088--mark--edd--
    
        AFTER FIELD oeo08
           IF NOT cl_null(l_oeo[i].oeo08) THEN
              IF l_oeo[i].oeo08 NOT MATCHES '[12]' THEN 
                 NEXT FIELD oeo08
              END IF
           END IF
 
        AFTER ROW 
           IF INT_FLAG THEN 
              EXIT INPUT
           END IF
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(oeo04)
#FUN-AA0059---------mod------------str-----------------              
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_ima"
#                   LET g_qryparam.default1 = l_oeo[i].oeo04
#                   CALL cl_create_qry() RETURNING l_oeo[i].oeo04
##                   CALL FGL_DIALOG_SETBUFFER( l_oeo[i].oeo04 )
                    CALL q_sel_ima(FALSE, "q_ima","",l_oeo[i].oeo04,"","","","","",'' ) 
                         RETURNING  l_oeo[i].oeo04

#FUN-AA0059---------mod------------end-----------------
                    DISPLAY l_oeo[i].oeo04 TO oeo04         #No.MOD-490371
                   NEXT FIELD oeo04
              WHEN INFIELD(oeo05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = l_oeo[i].oeo05
                   CALL cl_create_qry() RETURNING l_oeo[i].oeo05
#                   CALL FGL_DIALOG_SETBUFFER( l_oeo[i].oeo05 )
                    DISPLAY l_oeo[i].oeo05 TO oeo05         #No.MOD-490371
                   NEXT FIELD oeo05
              OTHERWISE  NEXT FIELD oeo04  
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END INPUT
 
    IF INT_FLAG THEN
       CALL cl_err('',9001,0)
       LET INT_FLAG = 0 
       CLOSE WINDOW t4006_w
       RETURN
   END IF
 
   CLOSE WINDOW t4006_w
 
   LET g_success ='Y' 
   
   DELETE FROM oeo_file WHERE oeo01 = p_no AND oeo03 = p_seq
 
   FOR i = 1 TO l_oeo.getLength()
       IF cl_null(l_oeo[i].oeo04) THEN CONTINUE FOR END IF
       IF cl_null(l_oeo[i].oeo06) THEN CONTINUE FOR END IF
       IF l_oeo[i].oeo06=0        THEN CONTINUE FOR END IF
          INSERT INTO oeo_file(oeo01,oeo03,oeo04,oeo05,oeo06,oeo07,
                                oeo08,oeo09,   #No.MOD-470041 
                               oeoplant,oeolegal)   #FUN-980010 add plant & legal 
                        VALUES(p_no,p_seq,l_oeo[i].oeo04,
                               l_oeo[i].oeo05,l_oeo[i].oeo06,
                               l_oeo[i].oeo07,l_oeo[i].oeo08, 
                               l_oeo[i].oeo09, g_plant,g_legal) #MOD-BA0001 mod l_oeo[j].oeo09應為l_oeo[i].oeo09
       IF SQLCA.sqlcode THEN
#         CALL cl_err('INS-oeo',SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("ins","oeo_file",p_no,p_seq,SQLCA.sqlcode,"","INS-oeo",0)   #No.FUN-660167
       ELSE
          MESSAGE "Insert :",l_oeo[i].oeo04
       END IF
    END FOR
 
END FUNCTION

#No.MOD-A70164  --Begin                                                         
FUNCTION s_t400oeo_u(p_no,p_seq,p_part,p_qty)                                   
   DEFINE p_qty          LIKE oeb_file.oeb12                                     
   DEFINE p_no           LIKE oea_file.oea01                                     
   DEFINE p_seq          LIKE type_file.num5                                     
   DEFINE p_part         LIKE bmb_file.bmb01                                     
   DEFINE l_n            LIKE type_file.num5   
   DEFINE l_oeo04        LIKE oeo_file.oeo04  #FUN-910088--add--         
   DEFINE l_oeo05        LIKE oeo_file.oeo05  #FUN-910088--add--         
   DEFINE l_oeo06        LIKE oeo_file.oeo06  #FUN-910088--add--                         
   DEFINE l_oeo09        LIKE oeo_file.oeo09  #FUN-910088--add--
   DEFINE l_sql       STRING  #FUN--910088--add--
                                                                              
   SELECT COUNT(*) INTO l_n FROM oeo_file                                        
    WHERE oeo01 = p_no                                                           
      AND oeo03 = p_seq                                                          
   IF cl_null(l_n) THEN LET l_n = 0 END IF                                       
   IF l_n = 0 THEN RETURN TRUE END IF  
#FUN-910088--add--start--                 
   LET l_sql= " SELECT oeo04,oeo05,oeo06 FROM oeo_file ",
              "  WHERE oeo01 = '",p_no,"'",
                "  AND oeo03 = '",p_seq,"'"
   PREPARE t400_pre FROM l_sql
   DECLARE t400_cs CURSOR  FOR t400_pre
   FOREACH t400_cs INTO l_oeo04,l_oeo05,l_oeo06
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         RETURN FALSE
      END IF
      LET l_oeo09 = l_oeo06 *  p_qty 
      LET l_oeo09 = s_digqty(l_oeo09,l_oeo05)
      UPDATE oeo_file SET oeo09 = l_oeo09   
       WHERE oeo01 = p_no
         AND oeo03 = p_seq
         AND oeo04 = l_oeo04
      IF SQLCA.sqlcode THEN
         CALL cl_err3('upd','oeo_file',p_no,p_seq,SQLCA.sqlcode,'','upd oeo',1)
         RETURN FALSE
      END IF
   END FOREACH
 #FUN-910088--add--end--
 #FUN-910088-mark-start--                                                                               
 #  UPDATE oeo_file SET oeo09 = oeo06 * p_qty                                     
 #   WHERE oeo01 = p_no                                                           
 #     AND oeo03 = p_seq                                                          
 #  IF SQLCA.sqlcode THEN                                                         
 #     CALL cl_err3('upd','oeo_file',p_no,p_seq,SQLCA.sqlcode,'','upd oeo',1)     
 #     RETURN FALSE                                                               
 #  END IF  
 #FUN-910088--mark--end--
    RETURN TRUE                                                                   
                                                                                
END FUNCTION                                                                    

#FUN-910088--add--start--
FUNCTION t400_oeo09_check(p_no,p_seq,l_oeo09,l_oeo09_t,l_oeo05,l_oeo05_t,l_oeo06,i,j) 
   DEFINE p_no LIKE oeb_file.oeb01,
          p_seq LIKE oeb_file.oeb03
   DEFINE l_oeb12 LIKE oeb_file.oeb12
   DEFINE l_oeo09,l_oeo09_t LIKE oeo_file.oeo09
   DEFINE l_oeo05,l_oeo05_t  LIKE oeo_file.oeo05
   DEFINE l_oeo06 LIKE oeo_file.oeo06
   DEFINE i,j LIKE type_file.num5
   IF NOT cl_null(l_oeo09) AND NOT cl_null(l_oeo05) THEN
      IF cl_null(l_oeo09_t) OR cl_null(l_oeo05_t) OR  l_oeo09_t != l_oeo09 OR l_oeo05_t != l_oeo05  THEN
         LET l_oeo09 = s_digqty(l_oeo09,l_oeo05)
         DISPLAY l_oeo09 TO s_oeo[i].oeo09
      END IF
   END IF
   IF NOT cl_null(l_oeo09) THEN
      IF l_oeo09 < 0 THEN
         RETURN FALSE,l_oeo06,l_oeo09 
      END IF
      SELECT oeb12 INTO l_oeb12 FROM oeb_file
       WHERE oeb01 = p_no AND oeb03 = p_seq
      IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
         IF l_oeb12 !=0 THEN
            LET l_oeo06 = l_oeo09 / l_oeb12
            DISPLAY l_oeo06 TO s_oeo[j].oeo06
         END IF
   END IF
   RETURN TRUE,l_oeo06,l_oeo09
END FUNCTION
#FUN-910088--add--end--
