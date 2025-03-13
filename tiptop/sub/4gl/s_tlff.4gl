# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_tlff.4gl
# Descriptions...: 將異動資料放入異動記錄檔中(製造管理)
# Usage..........: CALL s_tlff(p_flag,p_unit)
# Input Parameter: p_flag     1.第一單位 2.第二單位 
#                  p_unit     母單位
# Return Code....: None
# Modify.........: No.FUN-540022 05/04/11 By Carrier 雙單位內容修改
# Modify........ : No.FUN-560043 05/06/13 By ching add單別放大
# Modify.........: No.FUN-610070 06/02/19 alex 加入錯誤訊息處理方式
# Modify........ : No.TQC-620156 05/03/06 By kim 修改FUN-610070錯誤訊息處理方式
# Modify.........; NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0083 06/12/03 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-7C0127 07/12/10 By lumxa apmt731單身是同一個料號時 select rowid返回不止一列 審核時報錯    
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-980033 09/08/06 By lilingyu 出自境外倉出貨單當庫存扣帳時,ogb31訂單項次若為空白改傳出貨單號項次   
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-9B0184 09/11/23 By liuxqa SQL语法错误。
# Modify.........: No:MOD-9B0081 09/11/24 By sabrina tlff12值計算錯誤
# Modify.........: No:FUN-9B0149 09/11/30 By kim add tlff27
# Modify.........: No:TQC-9C0059 09/12/09 By sherry 重新過單
# Modify.........: No:FUN-A60028 10/06/24 BY lilingyu 平行工藝
# Modify.........: No:FUN-A70125 10/07/26 By lilingyu 平行工藝整批處理
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No:MOD-B20036 11/02/11 By sabrina 做換算率時不應控卡料號要為有效
# Modify.........: No:FUN-C70014 12/07/11 By wangwei 新增RUN CARD發料作業

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE g_chr           LIKE type_file.chr1     #No.FUN-680147 VARCHAR(1)
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose 	#No.FUN-680147 SMALLINT
 
FUNCTION s_tlff(p_flag,p_unit)
    DEFINE
        p_flag          LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
        p_unit          LIKE ima_file.ima25,
        l_cnt           LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_reason        LIKE apo_file.apo02, 	#No.FUN-680147 VARCHAR(4)
        s_f             LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        g_ima25         LIKE ima_file.ima25,
        l_ima906        LIKE ima_file.ima906,
        l_ima907        LIKE ima_file.ima907,
        l_img09         LIKE img_file.img09,    #No:MOD-9B0081 add
        l_rowid         LIKE type_file.row_id,  #chr18,   FUN-A70120
        l_flag          LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 
    WHENEVER ERROR CALL cl_err_msg_log
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( g_tlff.tlff01 ,g_plant) OR NOT s_internal_item( g_tlff.tlff01,g_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
 
    IF g_tlff.tlff021 IS NULL THEN LET g_tlff.tlff021=' ' END IF
    IF g_tlff.tlff022 IS NULL THEN LET g_tlff.tlff022=' ' END IF
    IF g_tlff.tlff023 IS NULL THEN LET g_tlff.tlff023=' ' END IF
    IF g_tlff.tlff031 IS NULL THEN LET g_tlff.tlff031=' ' END IF
    IF g_tlff.tlff032 IS NULL THEN LET g_tlff.tlff032=' ' END IF
    IF g_tlff.tlff033 IS NULL THEN LET g_tlff.tlff033=' ' END IF
    IF g_tlff.tlff027 IS NULL THEN LET g_tlff.tlff027 = 0 END IF
    IF g_tlff.tlff037 IS NULL THEN LET g_tlff.tlff037 = 0 END IF

#FUN-A60028 --begin--
      IF cl_null(g_tlff.tlff012) THEN LET g_tlff.tlff012 = ' ' END IF 
      IF cl_null(g_tlff.tlff013) THEN LET g_tlff.tlff013 = 0   END IF 
#FUN-A60028 --end--
 
    LET g_tlff.tlff07 = TODAY
    LET g_tlff.tlff08 = TIME  
    LET g_tlff.tlffplant = g_plant   #FUN-980012 add
    LET g_tlff.tlfflegal = g_legal   #FUN-920012 add
 
    IF g_tlff.tlff13 = 'aimp880' THEN LET g_tlff.tlff08='99:99:99' END IF
    IF cl_null(g_tlff.tlff12) THEN LET g_tlff.tlff12=1 END IF 
    IF cl_null(g_tlff.tlff026) THEN LET g_tlff.tlff026 = g_tlff.tlff036 END IF 
    IF cl_null(g_tlff.tlff036) THEN LET g_tlff.tlff036 = g_tlff.tlff026 END IF 
    IF g_tlff.tlff027=0 THEN LET g_tlff.tlff027 = g_tlff.tlff037 END IF  #MOD-980033                                                
    IF g_tlff.tlff037=0 THEN LET g_tlff.tlff037 = g_tlff.tlff027 END IF  #MOD-980033  
    IF g_tlff.tlff05 IS NULL THEN LET g_tlff.tlff05 =' ' END IF
 
    #------ 97/06/23
    LET g_tlff.tlff905='' #No:5416
    LET g_tlff.tlff906=0    
    LET g_tlff.tlff907=0
    LET g_tlff.tlff211=''
    LET g_tlff.tlff220=g_tlff.tlff11  #FUN-540024
    IF g_tlff.tlff02=50 AND g_tlff.tlff03=50 THEN
 
       PROMPT "來源與目的不可均為50:" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
          ON ACTION help
             CALL cl_show_help()
          ON ACTION about
             CALL cl_about()
       END PROMPT
 
       LET g_success='N'
       RETURN
    END IF
 
    IF g_tlff.tlff02=50 THEN                ##--- 出庫
       LET g_tlff.tlff902=g_tlff.tlff021
       LET g_tlff.tlff903=g_tlff.tlff022
       LET g_tlff.tlff904=g_tlff.tlff023
       LET g_tlff.tlff905=g_tlff.tlff026
       LET g_tlff.tlff906=g_tlff.tlff027
       LET g_tlff.tlff907=-1             
    END IF
 
    IF g_tlff.tlff03=50 THEN                ##--- 入庫
       LET g_tlff.tlff902=g_tlff.tlff031
       LET g_tlff.tlff903=g_tlff.tlff032
       LET g_tlff.tlff904=g_tlff.tlff033
       LET g_tlff.tlff905=g_tlff.tlff036
       LET g_tlff.tlff906=g_tlff.tlff037
       LET g_tlff.tlff907=1             
    END IF 
 
    ##--- 收貨不影響庫存,但仍應給 tlff90*的值
    IF g_tlff.tlff13='apmt1101' OR g_tlff.tlff13='asft6001' THEN   
       LET g_tlff.tlff902=g_tlff.tlff031
       LET g_tlff.tlff903=g_tlff.tlff032
       LET g_tlff.tlff904=g_tlff.tlff033
       LET g_tlff.tlff905=g_tlff.tlff036
       LET g_tlff.tlff906=g_tlff.tlff037
       LET g_tlff.tlff907=0             
    END IF
    LET g_tlff.tlff61=g_tlff.tlff905[1,g_doc_len]		#971028 Roger  #FUN-560043
    #--------------------------------------------------------------------------
    #MOD-4C0053(ADD IF...END IF)
    IF NOT cl_null(g_tlff.tlff902) THEN
        SELECT imd09 INTO g_tlff.tlff901
          FROM imd_file
         WHERE imd01=g_tlff.tlff902 AND imdacti = 'Y'
        IF STATUS THEN 
           LET g_success = 'N'
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              CALL s_errmsg('imd01',g_tlff.tlff902,'',STATUS,1)
           ELSE
             #CALL cl_err(g_tlff.tlff902,STATUS,1)     #FUN-670091
              CALL cl_err3("sel","imd_file",g_tlff.tlff902,"",STATUS,"","",1) #FUN-910091
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN
        END IF
    END IF
 
    SELECT ima25,ima906,ima907 INTO g_ima25,l_ima906,l_ima907 FROM ima_file
    #WHERE ima01=g_tlff.tlff01 AND imaacti='Y'      #MOD-B20036 mark
     WHERE ima01=g_tlff.tlff01                      #MOD-B20036 add
 
    CALL s_umfchk(g_tlff.tlff01,g_tlff.tlff11,g_ima25)
      RETURNING l_flag,g_tlff.tlff60
 
    IF l_flag AND NOT (l_ima906 = '3' AND p_flag = '2') THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          LET g_showmsg = g_tlff.tlff01,"/",g_tlff.tlff11,"/",g_ima25
          CALL s_errmsg('tlff01,tlff11,ima25',g_showmsg,'','abm-731',1)
       ELSE
          CALL cl_err('','abm-731',1)
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success='N'
       LET g_tlff.tlff60=1.0
    END IF
    IF STATUS OR g_tlff.tlff60 IS NULL THEN
       LET g_tlff.tlff60=1
    END IF
 
    #--------------------------------------------------------------------------
    IF (g_tlff.tlff02=50 OR g_tlff.tlff03=50) AND g_tlff.tlff13<>'aimp880' THEN
       IF NOT s_chksmz(g_tlff.tlff01,g_tlff.tlff905,g_tlff.tlff902,g_tlff.tlff903) #FUN-560043
          THEN LET g_success='N' RETURN
       END IF
    END IF
    #--------------------------------------------------------------------------
 
## 為了避免同一筆單據多人(sessoin)同時過帳造成 重複update img_file
## and insert tlff_file 
   #No.B627 委外採購入庫所產生之發料單時若分批入庫會重複,故必須加上目的單號
   #FUN-540024  --begin
   IF p_flag = '1' THEN LET g_tlff.tlff219=2 END IF
   IF p_flag = '2' THEN LET g_tlff.tlff219=1 END IF
   IF g_tlff.tlff13='asfi511' OR   g_tlff.tlff13='asfi519' THEN     #FUN-C70014 add g_tlff.tlff13='asfi519'
      SELECT COUNT(*) INTO g_i FROM tlff_file
       WHERE tlff01=g_tlff.tlff01
         AND tlff02=g_tlff.tlff02
         AND tlff03=g_tlff.tlff03
         AND tlff036=g_tlff.tlff036
         AND tlff902=g_tlff.tlff902
         AND tlff903=g_tlff.tlff903
         AND tlff904=g_tlff.tlff904
         AND tlff905=g_tlff.tlff905
         AND tlff906=g_tlff.tlff906
         AND tlff220=g_tlff.tlff220  #FUN-540024
         AND tlff219=g_tlff.tlff219  #FUN-540024
         AND tlff012=g_tlff.tlff012   #FUN-A60028 
         AND tlff013=g_tlff.tlff013   #FUN-A60028 
   ELSE
   #No.b627 end---
      #FUN-540024  --begin
      IF g_tlff.tlff902 IS NOT NULL OR g_tlff.tlff903 IS NOT NULL OR
         g_tlff.tlff904 IS NOT NULL THEN
         SELECT COUNT(*) INTO g_i FROM tlff_file
          WHERE tlff01=g_tlff.tlff01
            AND tlff02=g_tlff.tlff02
            AND tlff03=g_tlff.tlff03
            AND tlff902=g_tlff.tlff902
            AND tlff903=g_tlff.tlff903
            AND tlff904=g_tlff.tlff904
            AND tlff905=g_tlff.tlff905
            AND tlff906=g_tlff.tlff906
            AND tlff907=g_tlff.tlff907  #FUN-540024
            AND tlff220=g_tlff.tlff220  #FUN-540024
            AND tlff219=g_tlff.tlff219  #FUN-540024
            AND tlff012=g_tlff.tlff012   #FUN-A60028 
            AND tlff013=g_tlff.tlff013   #FUN-A60028             
      ELSE
         IF NOT cl_null(g_tlff.tlff021) THEN
            SELECT COUNT(*) INTO g_i FROM tlff_file
             WHERE tlff01=g_tlff.tlff01
               AND tlff02=g_tlff.tlff02
               AND tlff03=g_tlff.tlff03
               AND tlff021=g_tlff.tlff021
               AND tlff022=g_tlff.tlff022
               AND tlff023=g_tlff.tlff023
               AND tlff026=g_tlff.tlff026
               AND tlff027=g_tlff.tlff027
               AND tlff220=g_tlff.tlff220  #FUN-540024
               AND tlff219=g_tlff.tlff219  #FUN-540024
               AND tlff012=g_tlff.tlff012   #FUN-A60028 
               AND tlff013=g_tlff.tlff013   #FUN-A60028                
         END IF
         IF NOT cl_null(g_tlff.tlff031) THEN
            SELECT COUNT(*) INTO g_i FROM tlff_file
             WHERE tlff01=g_tlff.tlff01
               AND tlff02=g_tlff.tlff02
               AND tlff03=g_tlff.tlff03
               AND tlff031=g_tlff.tlff031
               AND tlff032=g_tlff.tlff032
               AND tlff033=g_tlff.tlff033
               AND tlff036=g_tlff.tlff036
               AND tlff037=g_tlff.tlff037
               AND tlff220=g_tlff.tlff220  #FUN-540024
               AND tlff219=g_tlff.tlff219  #FUN-540024
               AND tlff012=g_tlff.tlff012   #FUN-A60028 
               AND tlff013=g_tlff.tlff013   #FUN-A60028                
         END IF
      END IF
      #FUN-540024  --end
   END IF    #No.B627
   IF g_i>0 THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
         CALL s_errmsg('tlff01',g_tlff.tlff01,'s_tlff:ins tlff',-239,1)
       ELSE
          CALL cl_err('(s_tlff:ins tlff)',-239,1)
       END IF
       #-----No.FUN-6C0083 END-----
      LET g_success='N'
      RETURN
   END IF
   #FUN-540024  --begin
   IF p_flag = '1' THEN LET g_tlff.tlff219=2 END IF
   IF p_flag = '2' THEN LET g_tlff.tlff219=1 END IF
   IF p_flag = '1' THEN
      IF g_tlff.tlff902 IS NOT NULL OR g_tlff.tlff903 IS NOT NULL OR
         g_tlff.tlff904 IS NOT NULL THEN
         SELECT rowid INTO l_rowid FROM tlff_file
          WHERE tlff01 = g_tlff.tlff01
            AND tlff02 = g_tlff.tlff02
            AND tlff03 = g_tlff.tlff03
            AND tlff902= g_tlff.tlff902
            AND tlff903= g_tlff.tlff903
            AND tlff904= g_tlff.tlff904
            AND tlff905= g_tlff.tlff905
            AND tlff906= g_tlff.tlff906
            AND tlff907= g_tlff.tlff907
            AND tlff220= p_unit   #尋找母單位的rowid
            AND tlff012=g_tlff.tlff012   #FUN-A60028 
            AND tlff013=g_tlff.tlff013   #FUN-A60028             
      ELSE   
         IF NOT cl_null(g_tlff.tlff021) THEN
            SELECT rowid INTO l_rowid FROM tlff_file
             WHERE tlff01=g_tlff.tlff01
               AND tlff02=g_tlff.tlff02
               AND tlff03=g_tlff.tlff03
               AND tlff021=g_tlff.tlff021
               AND tlff022=g_tlff.tlff022
               AND tlff023=g_tlff.tlff023
               AND tlff026=g_tlff.tlff026
               AND tlff027=g_tlff.tlff027
               AND tlff220= p_unit   #尋找母單位的rowid
               AND tlff012=g_tlff.tlff012   #FUN-A60028 
               AND tlff013=g_tlff.tlff013   #FUN-A60028                
         END IF
         IF NOT cl_null(g_tlff.tlff031) THEN
            SELECT rowid INTO l_rowid FROM tlff_file
             WHERE tlff01=g_tlff.tlff01
               AND tlff02=g_tlff.tlff02
               AND tlff03=g_tlff.tlff03
               AND tlff031=g_tlff.tlff031
               AND tlff032=g_tlff.tlff032
               AND tlff033=g_tlff.tlff033
               AND tlff036=g_tlff.tlff036
               AND tlff037=g_tlff.tlff037
               AND tlff220= p_unit   #尋找母單位的rowid
               AND tlff012=g_tlff.tlff012   #FUN-A60028 
               AND tlff013=g_tlff.tlff013   #FUN-A60028                
         END IF
         #FUN-580029 --begin
         IF cl_null(g_tlff.tlff031) AND cl_null(g_tlff.tlff021)THEN
            SELECT rowid INTO l_rowid FROM tlff_file
             WHERE tlff01=g_tlff.tlff01
               AND tlff02=g_tlff.tlff02
               AND tlff03=g_tlff.tlff03
               AND tlff036=g_tlff.tlff036
               AND tlff026=g_tlff.tlff026
               AND tlff220= p_unit   #尋找母單位的rowid
               AND tlff012=g_tlff.tlff012   #FUN-A60028 
               AND tlff013=g_tlff.tlff013   #FUN-A60028                
         END IF
         #FUN-580029 --end
      END IF
      IF STATUS THEN
         IF NOT cl_null(p_unit) THEN
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
              CALL s_errmsg('tlff01',g_tlff.tlff01,'s_tlff:select parent rowid',STATUS,1)
            ELSE
               CALL cl_err3("sel","tlff_file","","",STATUS,"","s_tlff:select parent rowid",1) #FUN-670091
            END IF
            #-----No.FUN-6C0083 END-----
            LET g_success='N'
            RETURN
         ELSE
            LET p_flag='2'
         END IF
      ELSE
         LET g_tlff.tlff218 = l_rowid
      END IF
   END IF
   #FUN-540024  --end
#######

     #-----------No:MOD-9B0081 add
      SELECT img09 INTO l_img09 FROM img_file WHERE img01 = g_tlff.tlff01
                                                AND img02 = g_tlff.tlff902
                                                AND img03 = g_tlff.tlff903
                                                AND img04 = g_tlff.tlff904
      CALL s_umfchk(g_tlff.tlff01,g_tlff.tlff11,l_img09)
           RETURNING l_cnt,g_tlff.tlff12
      IF cl_null(g_tlff.tlff12) THEN LET g_tlff.tlff12=1 END IF       
     #-----------No:MOD-9B0081 end
     
#FUN-A70125 --begin--
      IF cl_null(g_tlff.tlff012) THEN
         LET g_tlff.tlff012 = ' ' 
      END IF 
      IF cl_null(g_tlff.tlff013) THEN
        LET g_tlff.tlff013 = 0 
      END IF 
#FUN-A70125 --end--

      #INSERT INTO tlff_file(tlff01,tlff02,tlff020,tlff021,tlff022,tlff023,tlff024,tlff025,tlff026,tlff027,tlff03,tlff030,tlff031,tlff032,tlff033,tlff034,tlff035,tlff036,tlff037,tlff04,tlff05,tlff06,tlff07,tlff08,tlff09,tlff10,tlff11,tlff12,tlff13,tlff14,tlff15,tlff16,tlff17,tlff18,tlff19,tlff20,tlff21,tlff211,tlff212,tlff2131,tlff2132,tlff214,tlff215,tlff2151,tlff216,tlff2171,tlff2172,tlff219,tlff218,tlff220,tlff221,tlff222,tlff2231,tlff2232,tlff224,tlff225,tlff2251,tlff226,tlff2271,tlff2272,tlff229,tlff230,tlff231,tlff60,tlff61,tlff62,tlff63,tlff64,tlff65,tlff66,tlff901,tlff902,tlff903,tlff904,tlff905,tlff906,tlff907,tlff908,tlff909,tlff910,tlff99, lff930,tlff931)
      INSERT INTO tlff_file(tlff01,tlff02,tlff020,tlff021,tlff022,tlff023,
         tlff024,tlff025,tlff026,tlff027,tlff03,tlff030,tlff031,tlff032,
         tlff033,tlff034,tlff035,tlff036,tlff037,tlff04,tlff05,tlff06,
         tlff07,tlff08,tlff09,tlff10,tlff11,tlff12,tlff13,tlff14,tlff15,
         tlff16,tlff17,tlff18,tlff19,tlff20,tlff21,tlff211,tlff212,
         tlff2131,tlff2132,tlff214,tlff215,tlff2151,tlff216,tlff2171,
         tlff2172,tlff219,tlff218,tlff220,tlff221,tlff222,tlff2231,
         tlff2232,tlff224,tlff225,tlff2251,tlff226,tlff2271,tlff2272,
         tlff229,tlff230,tlff231,tlff60,tlff61,tlff62,tlff63,tlff64,tlff65,
         tlff66,tlff901,tlff902,tlff903,tlff904,tlff905,tlff906,tlff907,
         tlff908,tlff909,tlff910,tlff99,tlff930,tlff931,                    #TQC-9B0184 mod
         tlffplant,tlfflegal,tlff27,tlff012,tlff013)      #FUN-9B0149  #FUN-A60028 add tlff012,tlff013
         VALUES (g_tlff.tlff01,g_tlff.tlff02,g_tlff.tlff020,g_tlff.tlff021,
         g_tlff.tlff022,g_tlff.tlff023,g_tlff.tlff024,g_tlff.tlff025,
         g_tlff.tlff026,g_tlff.tlff027,g_tlff.tlff03,g_tlff.tlff030,
         g_tlff.tlff031,g_tlff.tlff032,g_tlff.tlff033,g_tlff.tlff034,
         g_tlff.tlff035,g_tlff.tlff036,g_tlff.tlff037,g_tlff.tlff04,
         g_tlff.tlff05,g_tlff.tlff06,g_tlff.tlff07,g_tlff.tlff08,
         g_tlff.tlff09,g_tlff.tlff10,g_tlff.tlff11,g_tlff.tlff12,
         g_tlff.tlff13,g_tlff.tlff14,g_tlff.tlff15,g_tlff.tlff16,
         g_tlff.tlff17,g_tlff.tlff18,g_tlff.tlff19,g_tlff.tlff20,
         g_tlff.tlff21,g_tlff.tlff211,g_tlff.tlff212,g_tlff.tlff2131,
         g_tlff.tlff2132,g_tlff.tlff214,g_tlff.tlff215,g_tlff.tlff2151,
         g_tlff.tlff216,g_tlff.tlff2171,g_tlff.tlff2172,g_tlff.tlff219,
         g_tlff.tlff218,g_tlff.tlff220,g_tlff.tlff221,g_tlff.tlff222,
         g_tlff.tlff2231,g_tlff.tlff2232,g_tlff.tlff224,g_tlff.tlff225,
         g_tlff.tlff2251,g_tlff.tlff226,g_tlff.tlff2271,g_tlff.tlff2272,
         g_tlff.tlff229,g_tlff.tlff230,g_tlff.tlff231,g_tlff.tlff60,
         g_tlff.tlff61,g_tlff.tlff62,g_tlff.tlff63,g_tlff.tlff64,
         g_tlff.tlff65,g_tlff.tlff66,g_tlff.tlff901,g_tlff.tlff902,
         g_tlff.tlff903,g_tlff.tlff904,g_tlff.tlff905,g_tlff.tlff906,
         g_tlff.tlff907,g_tlff.tlff908,g_tlff.tlff909,g_tlff.tlff910,
         g_tlff.tlff99,g_tlff.tlff930,g_tlff.tlff931,
         g_tlff.tlffplant,g_tlff.tlfflegal,g_tlff.tlff27,g_tlff.tlff012,g_tlff.tlff013) #FUN-9B0149
                                        #FUN-A60028 add g_tlff.tlff012,g_tlff.tlff013
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('tlff01',g_tlff.tlff01,'s_tlff:ins tlff',STATUS,1)
       ELSE
         #CALL cl_err('(s_tlff:ins tlff)',STATUS,1)  #FUN-670091
          CALL cl_err3("ins","tlff_file","","",STATUS,"","",1)  #FUN-670091
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success='N'
       RETURN
    END IF
    
    IF p_flag = '2' THEN
      IF g_tlff.tlff902 IS NOT NULL OR g_tlff.tlff903 IS NOT NULL OR
         g_tlff.tlff904 IS NOT NULL THEN
          SELECT rowid INTO l_rowid FROM tlff_file
           WHERE tlff01 = g_tlff.tlff01
             AND tlff02 = g_tlff.tlff02
             AND tlff03 = g_tlff.tlff03
             AND tlff902= g_tlff.tlff902
             AND tlff903= g_tlff.tlff903
             AND tlff904= g_tlff.tlff904
             AND tlff905= g_tlff.tlff905
             AND tlff906= g_tlff.tlff906
             AND tlff907= g_tlff.tlff907
             AND tlff220= g_tlff.tlff220
             AND tlff012=g_tlff.tlff012   #FUN-A60028 
             AND tlff013=g_tlff.tlff013   #FUN-A60028              
       ELSE
         IF NOT cl_null(g_tlff.tlff021) THEN
            SELECT rowid INTO l_rowid FROM tlff_file
             WHERE tlff01=g_tlff.tlff01
               AND tlff02=g_tlff.tlff02
               AND tlff03=g_tlff.tlff03
               AND tlff021=g_tlff.tlff021
               AND tlff022=g_tlff.tlff022
               AND tlff023=g_tlff.tlff023
               AND tlff026=g_tlff.tlff026
               AND tlff027=g_tlff.tlff027
               AND tlff220= g_tlff.tlff220
               AND tlff012=g_tlff.tlff012   #FUN-A60028 
               AND tlff013=g_tlff.tlff013   #FUN-A60028                
         END IF
         IF NOT cl_null(g_tlff.tlff031) THEN
            SELECT rowid INTO l_rowid FROM tlff_file
             WHERE tlff01=g_tlff.tlff01
               AND tlff02=g_tlff.tlff02
               AND tlff03=g_tlff.tlff03
               AND tlff031=g_tlff.tlff031
               AND tlff032=g_tlff.tlff032
               AND tlff033=g_tlff.tlff033
               AND tlff036=g_tlff.tlff036
               AND tlff037=g_tlff.tlff037
               AND tlff220= g_tlff.tlff220
               AND tlff012=g_tlff.tlff012   #FUN-A60028 
               AND tlff013=g_tlff.tlff013   #FUN-A60028                
         END IF
         #FUN-580029 --begin
         IF cl_null(g_tlff.tlff031) AND cl_null(g_tlff.tlff021)THEN
            SELECT rowid INTO l_rowid FROM tlff_file
             WHERE tlff01=g_tlff.tlff01
               AND tlff02=g_tlff.tlff02
               AND tlff03=g_tlff.tlff03
               AND tlff036=g_tlff.tlff036
               AND tlff026=g_tlff.tlff026
               AND tlff037=g_tlff.tlff037    #TQC-7C0127
               AND tlff027=g_tlff.tlff027    #TQC-7C0127
               AND tlff220= g_tlff.tlff220
               AND tlff012=g_tlff.tlff012   #FUN-A60028 
               AND tlff013=g_tlff.tlff013   #FUN-A60028                
         END IF
         #FUN-580029 --end
       END IF
       IF STATUS THEN
          #-----No.FUN-6C0083-----
          IF g_bgerr THEN
             CALL s_errmsg('tlff01',g_tlff.tlff01,'s_tlff:select rowid',STATUS,1)
          ELSE
            #CALL cl_err('(s_tlff:select rowid)',STATUS,1)  #FUN-670091
             CALL cl_err3("sel","tlff_file","","",STATUS,"","s_tlff:select parent rowid",1) #FUN-670091
          END IF
          #-----No.FUN-6C0083 END-----
          LET g_success='N'
          RETURN
       ELSE
          LET g_tlff.tlff218 = l_rowid
          UPDATE tlff_file SET tlff218=g_tlff.tlff218 WHERE rowid=l_rowid
          IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
             #-----No.FUN-6C0083-----
             IF g_bgerr THEN
                CALL s_errmsg('tlff01',g_tlff.tlff01,'s_tlff:update tlff218',STATUS,1)
             ELSE
               #CALL cl_err('(s_tlff:update tlff218)',STATUS,1)      #FUN-670091
                CALL cl_err3("upd","tlff_file","","",STATUS,"","",1) #FUN-670091
             END IF
             #-----No.FUN-6C0083 END-----
             LET g_success ='N'
             RETURN
          END IF
       END IF
    END IF
    #FUN-540024  --end
    #--------------------------------------------------------------------------
END FUNCTION
#TQC-9C0059 
