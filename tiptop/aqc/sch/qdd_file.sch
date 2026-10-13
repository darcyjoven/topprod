/*
================================================================================
檔案代號:qdd_file
檔案名稱:样本数据档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qdd_file
(
qdd01       varchar2(20),            /*QC 单号                                */
                                     /*QC 單號                                */
qdd011      number(5),               /*QC 项次                                */
                                     /*QC 項次  (For IQC)                     */
qdd012      number(5),               /*QC 分批检验项次                        */
                                     /*QC 分批檢驗項次 (For IQC)              */
qdd013      number(5),               /*QC 单身项次                            */
                                     /*QC 單身項次                            */
qdd02       number(5),               /*组号                                   */
                                     /*組號                                   */
qdd03       number(15,3),            /*样本                                   */
                                     /*樣本                                   */
qddplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qddlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index qdd_01 on qdd_file (qdd01,qdd011,qdd012,qdd013,qdd02);
grant select on qdd_file to tiptopgp;
grant update on qdd_file to tiptopgp;
grant delete on qdd_file to tiptopgp;
grant insert on qdd_file to tiptopgp;
grant index on qdd_file to public;
grant select on qdd_file to ods;
