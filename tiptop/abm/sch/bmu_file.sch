/*
================================================================================
檔案代號:bmu_file
檔案名稱:E-BOM 插件位置
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmu_file
(
bmu01       varchar2(40) NOT NULL,   /*模拟主件料件编号                       */
                                     /*模擬主件料件編號                       */
bmu011      varchar2(10) NOT NULL,   /*版本                                   */
                                     /*版本 add in 2000/01/03                 */
bmu02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
bmu03       varchar2(40) NOT NULL,   /*元件料件编号                           */
                                     /*元件料件編號                           */
bmu04       date,                    /*No Use                                 */
bmu05       number(5) NOT NULL,      /*行序                                   */
bmu06       varchar2(10),            /*插件位置                               */
bmu07       number(16,8),            /*组成用量                               */
                                     /*組成用量   #NO:6542                    */
bmu08       varchar2(20) NOT NULL    /*特性代码                               */
);

alter table bmu_file add  constraint bmu_pk primary key  (bmu01,bmu011,bmu02,bmu03,bmu05,bmu08) enable validate;
grant select on bmu_file to tiptopgp;
grant update on bmu_file to tiptopgp;
grant delete on bmu_file to tiptopgp;
grant insert on bmu_file to tiptopgp;
grant index on bmu_file to public;
grant select on bmu_file to ods;
