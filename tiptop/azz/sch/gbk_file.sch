/*
================================================================================
檔案代號:gbk_file
檔案名稱:udm_tree流程图资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gbk_file
(
gbk01       varchar2(30) NOT NULL,   /*分类编号                               */
gbk02       number(5) NOT NULL,      /*顺序                                   */
gbk03       varchar2(80),            /*下层目录                               */
gbk04       varchar2(1) NOT NULL,    /*语言别                                 */
gbk05       varchar2(255),           /*Button名称                             */
gbk06       varchar2(255)            /*Button的隐藏说明                       */
);

alter table gbk_file add  constraint gbk_pk primary key  (gbk01,gbk02,gbk04) enable validate;
grant select on gbk_file to tiptopgp;
grant update on gbk_file to tiptopgp;
grant delete on gbk_file to tiptopgp;
grant insert on gbk_file to tiptopgp;
grant index on gbk_file to public;
grant select on gbk_file to ods;
