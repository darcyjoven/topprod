/*
================================================================================
檔案代號:opc_file
檔案名稱:产品销售预测单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table opc_file
(
opc01       varchar2(40) NOT NULL,   /*预测料件                               */
                                     /*預測料件                               */
opc02       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
opc03       date NOT NULL,           /*计划日期                               */
                                     /*計劃日期                               */
opc04       varchar2(10) NOT NULL,   /*业务员                                 */
                                     /*業務員                                 */
opc05       varchar2(10),            /*部门                                   */
                                     /*部門                                   */
opc06       varchar2(1),             /*计提方式                               */
                                     /*提列方式                               */
                                     /*1.依時距 2.天 3.週 4.旬 5.月           */
opc07       number(5),               /*生成期数                               */
                                     /*產生期數                               */
opc08       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
opc09       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
opc10       varchar2(10),            /*时距编号                               */
                                     /*時距代號                               */
opc11       varchar2(1),             /*业务审核                               */
                                     /*業務確認                               */
opc12       varchar2(1),             /*生管审核                               */
                                     /*生管確認                               */
opcsign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
opcdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
opcprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
opcsseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
opcsmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
opcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
opcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
opcgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
opcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
opcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
opcslk01    varchar2(20),            /*制单号，行业别字段                     */
opcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
opclegal    varchar2(10) NOT NULL,   /*所属法人                               */
opcoriu     varchar2(10),            /*资料建立者                             */
opcorig     varchar2(10)             /*资料建立部门                           */
);

alter table opc_file add  constraint opc_pk primary key  (opc01,opc02,opc03,opc04) enable validate;
grant select on opc_file to tiptopgp;
grant update on opc_file to tiptopgp;
grant delete on opc_file to tiptopgp;
grant insert on opc_file to tiptopgp;
grant index on opc_file to public;
grant select on opc_file to ods;
