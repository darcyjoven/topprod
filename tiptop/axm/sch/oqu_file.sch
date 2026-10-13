/*
================================================================================
檔案代號:oqu_file
檔案名稱:报价单单身资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqu_file
(
oqu01       varchar2(20) NOT NULL,   /*报价单号                               */
                                     /*報價單號                               */
oqu02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oqu03       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
oqu031      varchar2(120),           /*品名                                   */
oqu032      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
oqu04       varchar2(40),            /*客户料号                               */
                                     /*客戶料號                               */
oqu05       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
oqu06       number(15,3),            /*数量                                   */
                                     /*數量                                   */
oqu07       number(20,6),            /*报价单价                               */
                                     /*報價單價                               */
oqu08       varchar2(10),            /*生产地                                 */
                                     /*生產地                                 */
oqu09       number(15,3),            /*包装数量                               */
                                     /*包裝數量                               */
oqu10       varchar2(12),            /*包装单位                               */
                                     /*包裝單位                               */
oqu11       number(15,3),            /*材积 CFT                               */
                                     /*材積 CFT                               */
oqu12       number(15,3),            /*净重                                   */
                                     /*淨重                                   */
oqu13       number(15,3),            /*毛重                                   */
oqu14       varchar2(15),            /*包装方式                               */
oquud01     varchar2(255),           /*自订字段-Textedit                      */
oquud02     varchar2(40),            /*自订字段-文字                          */
oquud03     varchar2(40),            /*自订字段-文字                          */
oquud04     varchar2(40),            /*自订字段-文字                          */
oquud05     varchar2(40),            /*自订字段-文字                          */
oquud06     varchar2(40),            /*自订字段-文字                          */
oquud07     number(15,3),            /*自订字段-数值                          */
oquud08     number(15,3),            /*自订字段-数值                          */
oquud09     number(15,3),            /*自订字段-数值                          */
oquud10     number(10),              /*自订字段-整数                          */
oquud11     number(10),              /*自订字段-整数                          */
oquud12     number(10),              /*自订字段-整数                          */
oquud13     date,                    /*自订字段-日期                          */
oquud14     date,                    /*自订字段-日期                          */
oquud15     date,                    /*自订字段-日期                          */
oquplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqulegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oqu_file add  constraint oqu_pk primary key  (oqu01,oqu02) enable validate;
grant select on oqu_file to tiptopgp;
grant update on oqu_file to tiptopgp;
grant delete on oqu_file to tiptopgp;
grant insert on oqu_file to tiptopgp;
grant index on oqu_file to public;
grant select on oqu_file to ods;
