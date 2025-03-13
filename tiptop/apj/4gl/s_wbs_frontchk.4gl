# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_wbs_frontchk.4gl
#                : p_no          #WBS編碼
#                : p_no2         #活動代號 
#                : p_flag        #標志參數
# RETURING result: l_flag        #0.表示不存在  1.表示存在
# Descriptions...: 檢查WBS對應編碼前端是否有單據對應
# Create.........: No.FUN-790025 08/03/03 By douzh  項目預算管控功能調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds   
 
GLOBALS "../../config/top.global"  
 
FUNCTION s_wbs_frontchk(p_no,p_no2,p_flag)
DEFINE  p_no        LIKE pjb_file.pjb02         #WBS編碼
DEFINE  p_no2       LIKE pjk_file.pjk02         #活動代號
DEFINE  p_flag      LIKE type_file.chr1         #1.為WBS編碼,2.為活動代號
DEFINE  l_n         LIKE type_file.num5
DEFINE  l_flag      LIKE type_file.num5
 
  CASE p_flag
    WHEN '1'
      SELECT count(*) INTO l_n FROM apb_file
       WHERE apb36 = p_no
 
      IF l_n = 0 THEN
         SELECT count(*) INTO l_n FROM omb_file 
          WHERE omb42 = p_no 
         IF l_n = 0 THEN
            SELECT count(*) INTO l_n FROM fiw_file 
             WHERE fiw42 = p_no 
            IF l_n = 0 THEN
               SELECT count(*) INTO l_n FROM inb_file 
                WHERE inb42 = p_no 
               IF l_n = 0 THEN
                  SELECT count(*) INTO l_n FROM oeb_file 
                   WHERE oeb42 = p_no 
                  IF l_n = 0 THEN
                     SELECT count(*) INTO l_n FROM ogb_file 
                     WHERE ogb42 = p_no 
                     IF l_n = 0 THEN
                        SELECT count(*) INTO l_n FROM pmn_file 
                        WHERE pmn96 = p_no 
                        IF l_n = 0 THEN
                           SELECT count(*) INTO l_n FROM sfb_file 
                           WHERE sfb271 = p_no 
                           IF l_n = 0 THEN
                              SELECT count(*) INTO l_n FROM sfi_file 
                              WHERE sfi271 = p_no 
                              IF l_n = 0 THEN
                                 SELECT count(*) INTO l_n FROM sfv_file 
                                 WHERE sfv42 = p_no 
                                 IF l_n = 0 THEN
                                    SELECT count(*) INTO l_n FROM tlf_file 
                                    WHERE tlf41 = p_no 
                                    IF l_n = 0 THEN
                                       SELECT count(*) INTO l_n FROM pml_file 
                                       WHERE pml121 = p_no 
                                    ELSE
                                       LET l_flag = '1'
                                    END IF
                                 ELSE
                                    LET l_flag = '1'
                                 END IF
                              ELSE
                                 LET l_flag = '1'
                              END IF
                           ELSE
                              LET l_flag = '1'
                           END IF
                        ELSE
                           LET l_flag = '1'
                        END IF
                     ELSE
                        LET l_flag = '1'
                     END IF
                  ELSE
                     LET l_flag = '1'
                  END IF
               ELSE
                  LET l_flag = '1'
               END IF
            ELSE
               LET l_flag = '1'
            END IF
         ELSE
            LET l_flag = '1'
         END IF
      ELSE
         LET l_flag = '1'
      END IF
 
    WHEN '2'
      SELECT count(*) INTO l_n FROM fiw_file 
       WHERE fiw42 = p_no AND fiw43 = p_no2
      IF l_n = 0 THEN
         SELECT count(*) INTO l_n FROM inb_file 
          WHERE inb42 = p_no  AND inb43 = p_no2
         IF l_n = 0 THEN
            SELECT count(*) INTO l_n FROM oeb_file 
             WHERE oeb42 = p_no AND oeb43 = p_no2
            IF l_n = 0 THEN
               SELECT count(*) INTO l_n FROM ogb_file 
               WHERE ogb42 = p_no AND ogb43 = p_no2
               IF l_n = 0 THEN
                  SELECT count(*) INTO l_n FROM pmn_file 
                  WHERE pmn96 = p_no  AND pmn97 = p_no2
                  IF l_n = 0 THEN
                     SELECT count(*) INTO l_n FROM sfb_file 
                     WHERE sfb271 = p_no AND sfb50 = p_no2
                     IF l_n = 0 THEN
                        SELECT count(*) INTO l_n FROM sfi_file 
                        WHERE sfi271 = p_no AND sfi50 = p_no2
                        IF l_n = 0 THEN
                           SELECT count(*) INTO l_n FROM sfv_file 
                           WHERE sfv42 = p_no AND sfv43 = p_no2
                           IF l_n = 0 THEN
                              SELECT count(*) INTO l_n FROM tlf_file 
                              WHERE tlf41 = p_no AND tlf42 = p_no2
                              IF l_n = 0 THEN
                                 SELECT count(*) INTO l_n FROM pml_file 
                                 WHERE pml121 = p_no AND pml122 = p_no2
                              ELSE
                                 LET l_flag = '1'
                              END IF
                           ELSE
                              LET l_flag = '1'
                           END IF
                        ELSE
                           LET l_flag = '1'
                        END IF
                     ELSE
                        LET l_flag = '1'
                     END IF
                  ELSE
                     LET l_flag = '1'
                  END IF
               ELSE
                  LET l_flag = '1'
               END IF
            ELSE
               LET l_flag = '1'
            END IF
         ELSE
            LET l_flag = '1'
         END IF
      ELSE
         LET l_flag = '1'
      END IF
  OTHERWISE EXIT CASE 
  END CASE 
 
  RETURN l_flag
END FUNCTION
#No.FUN-790025
