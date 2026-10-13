/*
================================================================================
檔案代號:ohg_file
檔案名稱:客诉单处理说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ohg_file
(
ohg01       varchar2(20) NOT NULL,   /*客诉单号                               */
                                     /*客訴單號                               */
ohg02       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別                                   */
                                     /*1.調查結果                             */
                                     /*2.處理對策及改善對策                   */
                                     /*3.審核                                 */
                                     /*4.核決                                 */
                                     /*5.結案註記                             */
ohg03       number(5) NOT NULL,      /*行序                                   */
ohg04       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
ohg05       varchar2(1),             /*No Use                                 */
ohg06       varchar2(1),             /*No Use                                 */
ohgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ohglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ohg_file add  constraint ohg_pk primary key  (ohg01,ohg02,ohg03) enable validate;
grant select on ohg_file to tiptopgp;
grant update on ohg_file to tiptopgp;
grant delete on ohg_file to tiptopgp;
grant insert on ohg_file to tiptopgp;
grant index on ohg_file to public;
grant select on ohg_file to ods;
