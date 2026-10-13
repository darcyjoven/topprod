/*
================================================================================
檔案代號:crf_file
檔案名稱:成品/材料报关冲账差异记录单身档
檔案目的:记录成品/材料之异动/报关冲帐之报关差异资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table crf_file
(
crf01       varchar2(20) NOT NULL,   /*单据编号                               */
crf012      number(5) NOT NULL,      /*项次                                   */
crf02       number(5),               /*备案序号                               */
crf03       varchar2(40),            /*商品编号                               */
crf04       varchar2(1),             /*No Use                                 */
crf05       number(15,3),            /*数量                                   */
crf06       varchar2(4),             /*单位                                   */
crf07       number(20,6),            /*单价                                   */
crf08       number(20,6),            /*金额                                   */
crf09       number(5),               /*箱数                                   */
crf10       number(15,3),            /*净重（公斤）                           */
crf11       varchar2(10),            /*国家                                   */
crf12       varchar2(20),            /*单据编号                               */
crf13       number(5),               /*项次                                   */
crf14       number(15,3),            /*毛重（公斤）                           */
crf15       varchar2(10),            /*海关编号                               */
crfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
crflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index crf_02 on crf_file (crf12,crf13);
alter table crf_file add  constraint crf_pk primary key  (crf01,crf012) enable validate;
grant select on crf_file to tiptopgp;
grant update on crf_file to tiptopgp;
grant delete on crf_file to tiptopgp;
grant insert on crf_file to tiptopgp;
grant index on crf_file to public;
grant select on crf_file to ods;
