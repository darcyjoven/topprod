# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axmt811.4gl 
# Descriptions...: 訂單Notify/Consignee/Remark/Shipmark/Forward 資料維護
# Modify.........: 2000/02/09 By Kammy (為了一致性原則shipping mark 拿掉，
#                                       使用 axmi230 的客戶嘜頭資料 )
# Modify.........: No.FUN-590101 05/10/20 By Nicola 預設客戶慣用FORWARDER及NOTIFY
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-980010 09/08/24 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
#
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0314 10/11/29 By vealxu 插入oed_file 時報-391的錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_chr		LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_cust           LIKE oea_file.oea04
 
 
FUNCTION axmt811(p_no,p_cust,p_cmd)
   DEFINE ls_tmp      STRING
   DEFINE p_no        LIKE oea_file.oea01    #訂單單號
   DEFINE p_cust      LIKE oea_file.oea04    #送貨客戶
   DEFINE p_cmd	      LIKE type_file.chr1  		# u:update d:display only        #No.FUN-680137 VARCHAR(1)
   DEFINE i,j,s	      LIKE type_file.num5        # No.FUN-680137 SMALLINT
   DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_oci     RECORD LIKE oci_file.*
   DEFINE l_oed     RECORD LIKE oed_file.*,
          l_oed_t   RECORD LIKE oed_file.* 
 
   WHENEVER ERROR CONTINUE
 
   IF p_no IS NULL OR p_no=' '  THEN RETURN END IF
 
   LET g_cust=p_cust
   INITIALIZE l_oed.* TO NULL
 
   SELECT * INTO l_oed.* FROM oed_file
    WHERE oed01=p_no
   IF SQLCA.SQLCODE = 100 THEN
      #-----No.FUN-590101-----
      SELECT occ51,occ52 INTO l_oed.oed021,l_oed.oed041
        FROM occ_file
       WHERE occ01 = p_cust
      INSERT INTO oed_file(oed01,oed021,oed041,oedplant,oedlegal)
            VALUES(p_no,l_oed.oed021,l_oed.oed041,g_plant,g_legal)   #FUN-980010 add plant & legal 
      IF STATUS THEN
#        CALL cl_err("","9052",1)   #No.FUN-660167
         CALL cl_err3("ins","oed_file",p_no,"","9052","","",1)  #No.FUN-660167
         RETURN
      END IF
      #-----No.FUN-590101 END-----
      LET p_cmd="a"
   ELSE
      LET p_cmd="u"
   END IF
 
   LET l_oed.oed01=p_no    #訂單單號
   IF cl_null(l_oed.oed03) THEN LET l_oed.oed03='99' END IF
   IF cl_null(l_oed.oed04) THEN LET l_oed.oed04='90' END IF
   IF cl_null(l_oed.oed05) THEN LET l_oed.oed05='10' END IF
   IF cl_null(l_oed.oedplant) THEN LET l_oed.oedplant = g_plant END IF    #TQC-AB0314
   IF cl_null(l_oed.oedlegal) THEN LET l_oed.oedlegal = g_legal END IF    #TQC-AB0314
 
  #LET ls_tmp = g_prog CLIPPED           #在OPEN WIN附窗加這三行   
  #LET g_prog = 'axmt811'
   LET p_row = 5 LET p_col = 2 
   OPEN WINDOW axmt811_w AT p_row,p_col WITH FORM "axm/42f/axmt811"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_locale("axmt811")
 
       
   DISPLAY BY NAME l_oed.oed01,
                   l_oed.oed021,l_oed.oed022,l_oed.oed023,
                   l_oed.oed03,l_oed.oed030,l_oed.oed031,
                   l_oed.oed032,l_oed.oed033,l_oed.oed034,
                   l_oed.oed04,l_oed.oed040,l_oed.oed041,
                   l_oed.oed042,l_oed.oed043,l_oed.oed044,
                   l_oed.oed05,l_oed.oed050,l_oed.oed051,
                   l_oed.oed052,l_oed.oed053,l_oed.oed054,
                   l_oed.oed055,l_oed.oed056,l_oed.oed057,l_oed.oed058
                  
   LET l_oed_t.* = l_oed.*
 
   LET g_errno=' '
   WHILE TRUE
     INPUT BY NAME l_oed.oed01,
                l_oed.oed021,l_oed.oed022,l_oed.oed023,
                l_oed.oed03,l_oed.oed030,l_oed.oed031,
                l_oed.oed032,l_oed.oed033,l_oed.oed034,
                l_oed.oed04,l_oed.oed040,l_oed.oed041,
                l_oed.oed042,l_oed.oed043,l_oed.oed044,
                l_oed.oed05,l_oed.oed050,l_oed.oed051,
                l_oed.oed052,l_oed.oed053,l_oed.oed054,
                l_oed.oed055,l_oed.oed056,l_oed.oed057,l_oed.oed058
              WITHOUT DEFAULTS 
 
         AFTER FIELD oed030    #Consignee 序號
           IF NOT cl_null(l_oed.oed030) THEN 
              CALL t811_chk(l_oed.oed03,l_oed.oed030)
                    RETURNING l_oci.*
              IF g_errno <>' ' THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD oed030
              END IF
              IF p_cmd="a" OR (p_cmd="u" AND
                 (l_oed_t.oed030 IS NULL OR 
                  l_oed_t.oed030 <> l_oed.oed030)) THEN
                  LET l_oed.oed031=l_oci.oci11
                  LET l_oed.oed032=l_oci.oci12
                  LET l_oed.oed033=l_oci.oci13
                  LET l_oed.oed034=l_oci.oci14
                  DISPLAY BY NAME l_oed.oed031,l_oed.oed032,
                                  l_oed.oed033,l_oed.oed034
              END IF 
            END IF
 
         AFTER FIELD oed040    #Notify 序號
           IF NOT cl_null(l_oed.oed040) THEN 
              CALL t811_chk(l_oed.oed04,l_oed.oed040)
                    RETURNING l_oci.*
              IF g_errno <>' ' THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD oed040
              END IF
              IF p_cmd="a" OR (p_cmd="u" AND
                 (l_oed_t.oed040 IS NULL OR 
                  l_oed_t.oed040 <> l_oed.oed040)) THEN
                  LET l_oed.oed041=l_oci.oci11
                  LET l_oed.oed042=l_oci.oci12
                  LET l_oed.oed043=l_oci.oci13
                  LET l_oed.oed044=l_oci.oci14
                  DISPLAY BY NAME l_oed.oed041,l_oed.oed042,
                                  l_oed.oed043,l_oed.oed044
              END IF 
            END IF
 
         AFTER FIELD oed050    #Notify 序號
           IF NOT cl_null(l_oed.oed050) THEN 
              CALL t811_chk(l_oed.oed05,l_oed.oed050)
                    RETURNING l_oci.*
              IF g_errno <>' ' THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD oed050
              END IF
              IF p_cmd="a" OR (p_cmd="u" AND
                 (l_oed_t.oed050 IS NULL OR 
                  l_oed_t.oed050 <> l_oed.oed050)) THEN
                  LET l_oed.oed051=l_oci.oci11
                  LET l_oed.oed052=l_oci.oci12
                  LET l_oed.oed053=l_oci.oci13
                  LET l_oed.oed054=l_oci.oci14
                  LET l_oed.oed055=l_oci.oci15
                  LET l_oed.oed056=l_oci.oci16
                  LET l_oed.oed057=l_oci.oci17
                  LET l_oed.oed058=l_oci.oci18
                  DISPLAY BY NAME l_oed.oed051,l_oed.oed052,
                                  l_oed.oed053,l_oed.oed054,
                                  l_oed.oed055,l_oed.oed056,
                                  l_oed.oed057,l_oed.oed058 
              END IF 
            END IF
 
        ON ACTION controlp                  
          CASE WHEN INFIELD(oed030) #查詢序號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oci1"
                    LET g_qryparam.default1 = l_oed.oed030
                    LET g_qryparam.arg1     = p_cust
                    LET g_qryparam.arg2     = l_oed.oed03
                    CALL cl_create_qry() RETURNING l_oed.oed030
#                    CALL FGL_DIALOG_SETBUFFER( l_oed.oed030 )
                    DISPLAY BY NAME l_oed.oed030
                    NEXT FIELD oed030
               WHEN INFIELD(oed040) #查詢序號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oci1"
                    LET g_qryparam.default1 = l_oed.oed040
                    LET g_qryparam.arg1     = p_cust
                    LET g_qryparam.arg2     = l_oed.oed04
                    CALL cl_create_qry() RETURNING l_oed.oed040
#                    CALL FGL_DIALOG_SETBUFFER( l_oed.oed040 )
                    DISPLAY BY NAME l_oed.oed040
                    NEXT FIELD oed040
               WHEN INFIELD(oed050) #查詢序號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oci"
                    LET g_qryparam.default1 = l_oed.oed050
                    LET g_qryparam.arg1     = p_cust
                    LET g_qryparam.arg2     = l_oed.oed05
                    CALL cl_create_qry() RETURNING l_oed.oed050
#                    CALL FGL_DIALOG_SETBUFFER( l_oed.oed050 )
                    DISPLAY BY NAME l_oed.oed050
                    NEXT FIELD oed050
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       EXIT WHILE
    END IF
 
    UPDATE oed_file SET * = l_oed.*
     WHERE oed01=l_oed.oed01
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('upd oed:',sqlca.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("upd","oed_file",l_oed.oed01,"",sqlca.sqlcode,"","upd oed",1)  #No.FUN-660167
    END IF
 
    EXIT WHILE
  END WHILE
 
  CLOSE WINDOW axmt811_w 
 #LET g_prog = ls_tmp 
 
END FUNCTION
 
FUNCTION t811_chk(l_type,l_seq)  
    DEFINE l_type LIKE oci_file.oci02,    #類別
           l_seq  LIKE oci_file.oci03     #序號
    DEFINE l_oci  RECORD LIKE oci_file.*
 
    LET g_errno=' '
    INITIALIZE l_oci.* TO NULL
    IF l_type IS NULL OR l_seq IS NULL THEN RETURN END IF
    SELECT * INTO l_oci.* FROM oci_file
     WHERE oci01 =g_cust
       AND oci02 = l_type
       AND oci03 = l_seq
    IF SQLCA.SQLCODE <> 0 THEN
       LET g_errno='axm-343' 
    END IF
    RETURN l_oci.*
END FUNCTION
