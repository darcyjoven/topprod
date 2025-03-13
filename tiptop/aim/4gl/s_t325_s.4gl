# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.TQC-5C0071 05/12/14 By kim 宣告變數型態改用LIKE
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-670093 06/07/20 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-760153 07/06/18 By chenl  增加傳入參數p_tlf14理由碼。
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.TQC-930155 09/04/14 By Zhangyajun UPDATE img_file 前先Lock
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-AA0086 10/10/15 By Carrier 批序号管理
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_i  LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
FUNCTION s_t325_s(p_part,p_ware,p_loc,p_lot,p_type,p_qty,p_unit,p_no,p_seq,
                  p_tlf06,p_tlf14)         #No.TQC-760153  add p_tlf14
    DEFINE #p_part,p_ware,p_loc,p_lot VARCHAR(20), #TQC-5C0071
           p_part     LIKE img_file.img01,   #TQC-5C0071
           p_ware     LIKE img_file.img02,   #TQC-5C0071
           p_loc      LIKE img_file.img03,   #TQC-5C0071
           p_lot      LIKE img_file.img04,   #TQC-5C0071
           p_type     LIKE type_file.num5,   #-1.出 1.入  #No.FUN-690026 SMALLINT
           p_qty      LIKE img_file.img10,   #MOD-530179
          #p_unit     VARCHAR(4), #TQC-5C0071
           p_unit     LIKE img_file.img09,   #TQC-5C0071
           p_no       LIKE imn_file.imn01,   #No.FUN-690026 VARCHAR(16),                #No.FUN-550029
           p_seq      LIKE type_file.num5,   #No.FUN-690026 SMALLINT
           p_tlf06    LIKE tlf_file.tlf06,   #No.B037 010326 add 
           p_tlf14    LIKE tlf_file.tlf14,   #No.TQC-760153 add
           l_img      RECORD LIKE img_file.*,
           l_imn9301  LIKE imn_file.imn9301, #FUN-670093
           l_imn9302  LIKE imn_file.imn9302  #FUN-670093
    DEFINE g_sql STRING  #No.TQC-930155
    DEFINE l_ima01 LIKE ima_file.ima01 #No.TQC-930155
    WHENEVER ERROR CALL cl_err_msg_log   #No.TQC-930155
 
    INITIALIZE l_img.* TO NULL
#No.TQC-930155--start--
    LET g_sql = "SELECT  img_file.* FROM img_file ",
                " WHERE img01 = ? AND img02 = ? ",
                "   AND img03 = ? AND img04 = ? FOR UPDATE"
    LET g_sql=cl_forupd_sql(g_sql)

    DECLARE img_lock CURSOR FROM g_sql
    OPEN img_lock USING p_part,p_ware,p_loc,p_lot
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:",STATUS,1)
       LET g_success = 'N'
       CLOSE img_lock
       RETURN
    END IF
    FETCH img_lock INTO  l_img.*
    IF STATUS THEN
       IF STATUS = 100 THEN
          CALL s_t325_add_img(p_part,p_ware,p_loc,p_lot,p_unit,p_no,p_seq)
          SELECT  img_file.* INTO  l_img.* FROM img_file
               WHERE img01=p_part AND img02=p_ware AND img03=p_loc AND img04=p_lot
       ELSE
          CALL cl_err3("sel","img_file",p_part,p_ware,SQLCA.sqlcode,"","sel img",1)
          LET g_success = 'N'
          CLOSE img_lock
          RETURN
       END IF
    END IF
#    SELECT  img_file.* INTO  l_img.* FROM img_file
#     WHERE img01=p_part AND img02=p_ware AND img03=p_loc AND img04=p_lot
#    IF SQLCA.SQLCODE AND p_type='-1' THEN 
#       #CALL cl_err('sel img',STATUS,1) 
#       CALL cl_err3("sel","img_file",p_part,p_ware,SQLCA.sqlcode,"","sel img",1)   #NO.FUN-640266  #No.FUN-660156
#       LET g_success = 'N' RETURN
#    END IF
#No.TQC-930155--end--
    IF SQLCA.SQLCODE THEN
       CALL s_t325_add_img(p_part,p_ware,p_loc,p_lot,p_unit,p_no,p_seq)
       SELECT  img_file.* INTO  l_img.* FROM img_file
        WHERE img01=p_part AND img02=p_ware AND img03=p_loc AND img04=p_lot
    END IF
    CALL s_upimg(p_part,p_ware,p_loc,p_lot,p_type,p_qty,TODAY,'','','','', #FUN-8C0084
               # '','','','','','','','','','','','','','')                #No.MOD-AA0086
                 p_no,p_seq,'','','','','','','','','','','','')                #No.MOD-AA0086
    IF g_success='N' THEN RETURN END IF

    LET g_sql = "SELECT ima01 FROM ima_file WHERE ima01= ?  FOR UPDATE "
    LET g_sql=cl_forupd_sql(g_sql)

    DECLARE ima_lock CURSOR FROM g_sql
    OPEN ima_lock USING l_img.img01
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N'
       RETURN
    END IF
    FETCH ima_lock INTO l_ima01
    IF STATUS THEN
       CALL cl_err('sel ima_file fail',STATUS,1)
       LET g_success='N'
       RETURN
    END IF
#No.TQC-930155--end--
    CALL s_udima(l_img.img01,l_img.img23,l_img.img24,p_qty*l_img.img21,
                 TODAY,p_type) RETURNING g_i
   #No.+052 010404 by plum
    IF g_success='N' THEN RETURN END IF
   #No.+052 010404 by plum
    #FUN-670093...............begin
    SELECT imn9301,imn9302 INTO l_imn9301,l_imn9302 
                           FROM imn_file
                          WHERE imn01=p_no
                            AND imn02=p_seq
    IF SQLCA.sqlcode THEN
       LET l_imn9301=NULL
       LEt l_imn9302=NULL
    END IF
    #FUN-670093...............end
    #----來源----
    INITIALIZE g_tlf.* TO NULL
    LET g_tlf.tlf01 =l_img.img01 	        #異動料件編號
    LET g_tlf.tlf020=g_plant                    #工廠別
    LET g_tlf.tlf021=l_img.img02   	        #倉庫別
    LET g_tlf.tlf022=l_img.img03	        #儲位別
    LET g_tlf.tlf023=l_img.img04         	#批號
    LET g_tlf.tlf024=l_img.img10-p_qty          #異動後庫存數量
    LET g_tlf.tlf025=l_img.img09                #庫存單位(ima_file or img_file)
    LET g_tlf.tlf026=p_no                       #調撥單號
    LET g_tlf.tlf027=p_seq                      #項次
    #----目的----
    LET g_tlf.tlf030=g_plant                    #工廠別
    LET g_tlf.tlf031=l_img.img02                #倉庫別
    LET g_tlf.tlf032=l_img.img03                #儲位別
    LET g_tlf.tlf033=l_img.img04  	        #批號
    LET g_tlf.tlf034=l_img.img10+p_qty          #異動後庫存量
    LET g_tlf.tlf035=l_img.img09             	#庫存單位(ima_file or img_file)
    LET g_tlf.tlf036=p_no                       #參考號碼
    LET g_tlf.tlf037=p_seq                      #項次      
 
    IF p_type = -1  THEN #-- 出
       LET g_tlf.tlf02=50         	 	
       LET g_tlf.tlf03=99         	 	
       LET g_tlf.tlf030=' '                    
       LET g_tlf.tlf031=' '                   
       LET g_tlf.tlf032=' '                   
       LET g_tlf.tlf033=' '          	       
       LET g_tlf.tlf034=0 
       LET g_tlf.tlf035=' '
       LET g_tlf.tlf036=' '
       LET g_tlf.tlf037=0
       LET g_tlf.tlf930=l_imn9301 #FUN-670093
    ELSE               #-- 入
       LET g_tlf.tlf02=99         	 	
       LET g_tlf.tlf03=50         	 	
       LET g_tlf.tlf020=' '                    
       LET g_tlf.tlf021=' '                  
       LET g_tlf.tlf022=' '                  
       LET g_tlf.tlf023=' '                  
       LET g_tlf.tlf024=0 
       LET g_tlf.tlf025=' '                    
       LET g_tlf.tlf026=' '
       LET g_tlf.tlf027=0
       LET g_tlf.tlf930=l_imn9302 #FUN-670093
    END IF
#--->異動數量
    LET g_tlf.tlf04=' '                         #工作站
    LET g_tlf.tlf05=' '                         #作業序號
  # LET g_tlf.tlf06=TODAY                       #發料日期
    LET g_tlf.tlf06=p_tlf06                     #發料日期 No.B037 010326 mod
    LET g_tlf.tlf07=TODAY                       #異動資料產生日期  
    LET g_tlf.tlf08=TIME                        #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user                      #產生人
    LET g_tlf.tlf10=p_qty                       #調撥數量
    LET g_tlf.tlf11=l_img.img09                 #撥出單位
    LET g_tlf.tlf12=1                           #撥出/撥入庫存轉換率
    LET g_tlf.tlf13='aimt325'                   #異動命令代號
   #LET g_tlf.tlf14=' '                         #異動原因         #No.TQC-760153 mark
    LET g_tlf.tlf14=p_tlf14                     #異動原因         #No.TQC-760153
    LET g_tlf.tlf15=' '                         #借方會計科目
    LET g_tlf.tlf16=' '                         #貸方會計科目
    LET g_tlf.tlf17=' '                         #remark
    CALL s_imaQOH(l_img.img01) RETURNING g_tlf.tlf18   #異動後總庫存量
    LET g_tlf.tlf19= ' '                        #異動廠商/客戶編號
    LET g_tlf.tlf20= ' '                        #project no.      
    LET g_tlf.tlf61= ' '     
    CALL s_tlf(0,0)
   #No.+052 010404 by plum
    IF g_success='N' THEN RETURN END IF
   #No.+052 010404 by plum
END FUNCTION
 
FUNCTION s_t325_add_img(p_part,p_ware,p_loca,p_lot,p_unit,p_no,p_seq)
  DEFINE #p_part  VARCHAR(20),             #TQC-5C0071
         #p_ware  VARCHAR(10),		##倉庫  #TQC-5C0071
         #p_loca  VARCHAR(10),		##儲位  #TQC-5C0071
         #p_lot   VARCHAR(20),		##批號  #TQC-5C0071
          p_part  LIKE img_file.img01,  #TQC-5C0071
          p_ware  LIKE img_file.img02,	##倉庫 #TQC-5C0071
          p_loca  LIKE img_file.img03,	##儲位 #TQC-5C0071
          p_lot   LIKE img_file.img04,	##批號 #TQC-5C0071
          p_no    LIKE imn_file.imn01,  # No.FUN-550029  #No.FUN-690026 VARCHAR(16)
          p_seq   LIKE type_file.num5,  #No.FUN-690026 SMALLINT
         #p_unit  VARCHAR(4),		##UOM #TQC-5C0071
          p_unit  LIKE img_file.img09,		##UOM #TQC-5C0071
          l_img   RECORD LIKE img_file.*,
         #l_ima25 VARCHAR(4), #TQC-5C0071
          l_ima25 LIKE ima_file.ima25,  #TQC-5C0071
          l_ima71 LIKE type_file.num5   #No.FUN-690026 SMALLINT
 
   INITIALIZE l_img.* TO NULL
   LET l_img.img01=p_part
   LET l_img.img02=p_ware
   LET l_img.img03=p_loca
 
   # 檢查是否有相對應的倉庫/儲位資料存在,若無則自動新增一筆資料
   CALL s_locchk(l_img.img01,l_img.img02,l_img.img03) RETURNING g_i,l_img.img26
   IF g_i = 0 THEN LET g_errno='N' RETURN END IF
 
   LET l_img.img04=p_lot
   LET l_img.img05=p_no
   LET l_img.img06=p_seq
   LET l_img.img09=p_unit
   SELECT ima25,ima71 INTO l_ima25,l_ima71 FROM ima_file WHERE ima01=p_part
   LET l_img.img10=0
   LET l_img.img13=null
   LET l_img.img15=TODAY
   LET l_img.img17=TODAY
   IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
   IF l_ima71 =0
      THEN LET l_img.img18=g_lastdat
      ELSE LET l_img.img13=TODAY
           LET l_img.img18=TODAY+l_ima71
   END IF
   LET l_img.img20=1
   LET l_img.img21=1
   CALL s_umfchk(l_img.img01,l_img.img09,l_ima25) RETURNING g_i,l_img.img21
   ##Modify:98/11/13 -------單位換算率抓不到--------###  
   IF g_i = 1 THEN 
      CALL cl_err('','abm-731',1)
   END IF 
   ##------------------------------------------------###
   SELECT imd10,imd11,imd12,imd13
          INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25
          FROM imd_file
         WHERE imd01=l_img.img02
            AND imdacti = 'Y' #MOD-4B0169
   IF STATUS THEN 
#     CALL cl_err('sel imd:',STATUS,1) 
      CALL cl_err3("sel","imd_file",l_img.img02,"",SQLCA.sqlcode,"","sel imd",1)   #NO.FUN-640266 #No.FUN-660156
      LET g_success='N' 
   END IF
   LET l_img.img30=0
   LET l_img.img31=0
   LET l_img.img32=0
   LET l_img.img33=0
   LET l_img.img34=1
   IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
   IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
   IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
   LET l_img.imgplant = g_plant #FUN-980004 add
   LET l_img.imglegal = g_legal #FUN-980004 add
   INSERT INTO img_file VALUES (l_img.*)
  #No.+035 010329 by plum
  #IF STATUS THEN CALL cl_err('ins img',STATUS,1) LET g_success='N' END IF
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('ins img: ',SQLCA.SQLCODE,1)
      CALL cl_err3("ins","img_file",l_img.img01,"",SQLCA.sqlcode,"","ins img",1)   #NO.FUN-640266 #No.FUN-660156
      LET g_success='N' 
   END IF
  #No.+035..end
END FUNCTION
