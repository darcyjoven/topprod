/*
================================================================================
檔案代號:amf_file
檔案名稱:进销项凭证单身资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table amf_file
(
amf01       varchar2(20) NOT NULL,   /*帐款单号/凭证编号 对应                 */
                                     /*帳款單號/傳票編號                      */
amf02       number(5) NOT NULL,      /*项次 对应                              */
                                     /*項次                                   */
amf021      varchar2(1) NOT NULL,    /*来源类型                               */
                                     /*來源類別                               */
                                     /*1 : 總帳(GL)                           */
                                     /*2 : 應付(AP)                           */
                                     /*3 : 應收(AR)                           */
                                     /*4.: 其他(OT)                           */
                                     /*5.: 應付(AP)                           */
amf022      varchar2(20) NOT NULL,   /*参考单号                               */
amf03       number(5) NOT NULL,      /*序号 单身之序号                        */
                                     /*序號 單身之序號                        */
                                     /*對應 omb03 /oga03                      */
amf04       varchar2(40),            /*产品编号                               */
                                     /*產品編號 ima01/ogb04/ohb04             */
amf06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
amf07       number(15,3),            /*数量                                   */
                                     /*數量                                   */
amflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table amf_file add  constraint amf_pk primary key  (amf01,amf02,amf021,amf022,amf03) enable validate;
grant select on amf_file to tiptopgp;
grant update on amf_file to tiptopgp;
grant delete on amf_file to tiptopgp;
grant insert on amf_file to tiptopgp;
grant index on amf_file to public;
grant select on amf_file to ods;
