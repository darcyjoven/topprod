/*
================================================================================
檔案代號:nnu_file
檔案名稱:担保票券融资贷款档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnu_file
(
nnu01       varchar2(20) NOT NULL,   /*相关单号                               */
                                     /*相關單號                               */
nnu02       number(5) NOT NULL,      /*行序                                   */
nnu03       varchar2(4),             /*票券类型                               */
                                     /*票券類別                               */
nnu04       varchar2(80),            /*投资标的                               */
                                     /*投資標的                               */
nnu05       varchar2(15),            /*票券号码                               */
                                     /*票券號碼                               */
nnu06       varchar2(80),            /*票券名称                               */
                                     /*票券名稱                               */
nnu07       number(5),               /*张数                                   */
                                     /*張數                                   */
nnu08       number(20,6),            /*票面金额                               */
                                     /*票面金額                               */
nnu09       varchar2(1),             /*No Use                                 */
nnu10       varchar2(1),             /*No Use                                 */
nnulegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nnu_file add  constraint nnu_pk primary key  (nnu01,nnu02) enable validate;
grant select on nnu_file to tiptopgp;
grant update on nnu_file to tiptopgp;
grant delete on nnu_file to tiptopgp;
grant insert on nnu_file to tiptopgp;
grant index on nnu_file to public;
grant select on nnu_file to ods;
