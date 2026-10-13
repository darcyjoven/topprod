/*
================================================================================
檔案代號:ooa_file
檔案名稱:冲账单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ooa_file
(
ooa01       varchar2(20) NOT NULL,   /*冲帐单号                               */
                                     /*沖帳單號                               */
ooa02       date,                    /*冲帐日期                               */
                                     /*沖帳日期                               */
ooa021      date,                    /*录入日期                               */
                                     /*輸入日期                               */
ooa03       varchar2(10),            /*帐款客户编号                           */
                                     /*帳款客戶編號                           */
ooa032      varchar2(40),            /*帐款客户简称                           */
                                     /*帳款客戶簡稱                           */
ooa13       varchar2(10),            /*科目分类码                             */
                                     /*科目分類碼                             */
ooa14       varchar2(10),            /*人员编号                               */
                                     /*人員編號                               */
ooa15       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
ooa20       varchar2(1),             /*分录底稿是否可重新生成                 */
                                     /*分錄底稿是否可重新產生(Y/N)            */
                                     /*  設為'N'時表示分錄底稿有經過人為修改, */
                                     /*  當執行'分錄產生'時, 不可再產生       */
ooa23       varchar2(4),             /*币种                                   */
                                     /*幣別 非空白:同幣別沖帳 空白:不同幣別沖帳*/
ooa24       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
ooa25       varchar2(1),             /*差异处理                               */
                                     /*差異處理                               */
                                     /*  0.無差異                             */
                                     /*  1.視為暫收-溢收                      */
                                     /*  2.視為收款折扣                       */
                                     /*  3.視為匯兌損益                       */
                                     /*  4.留置, 待更正                       */
ooa31d      number(20,6) NOT NULL,   /*原币借方金额合计                       */
                                     /*原幣借方金額合計                       */
ooa31c      number(20,6) NOT NULL,   /*原币贷方金额合计                       */
                                     /*原幣貸方金額合計                       */
ooa32d      number(20,6) NOT NULL,   /*本币借方金额合计                       */
                                     /*本幣借方金額合計                       */
ooa32c      number(20,6) NOT NULL,   /*本币贷方金额合计                       */
                                     /*本幣貸方金額合計                       */
ooa33       varchar2(20),            /*抛转凭证号                             */
                                     /*拋轉傳票號                             */
ooaconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N/X)                         */
ooaprsw     number(5),               /*打印次数                               */
                                     /*列印次數                               */
ooauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ooagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ooamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ooadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ooa34       varchar2(1),             /*状况码                                 */
ooamksg     varchar2(1),             /*签核否？                               */
ooa00       varchar2(1),             /*收款性质(1.转应收帐款 2.直接           */
ooa992      varchar2(20),            /*集团代付单号                           */
                                     /*For 內部帳戶                           */
ooaud01     varchar2(255),           /*自订字段-Textedit                      */
ooaud02     varchar2(40),            /*自订字段-文字                          */
ooaud03     varchar2(40),            /*自订字段-文字                          */
ooaud04     varchar2(40),            /*自订字段-文字                          */
ooaud05     varchar2(40),            /*自订字段-文字                          */
ooaud06     varchar2(40),            /*自订字段-文字                          */
ooaud07     number(15,3),            /*自订字段-数值                          */
ooaud08     number(15,3),            /*自订字段-数值                          */
ooaud09     number(15,3),            /*自订字段-数值                          */
ooaud10     number(10),              /*自订字段-整数                          */
ooaud11     number(10),              /*自订字段-整数                          */
ooaud12     number(10),              /*自订字段-整数                          */
ooaud13     date,                    /*自订字段-日期                          */
ooaud14     date,                    /*自订字段-日期                          */
ooaud15     date,                    /*自订字段-日期                          */
ooa35       varchar2(1),             /*退款类型                               */
ooa36       varchar2(20),            /*参考单号                               */
ooa37       varchar2(1),             /*冲帐类型                               */
                                     /*1.收款 2.退款 3.转销                   */
ooa38       varchar2(1),             /*来源类型                               */
ooalegal    varchar2(10) NOT NULL,   /*所属法人                               */
ooaoriu     varchar2(10),            /*资料建立者                             */
ooaorig     varchar2(10),            /*资料建立部门                           */
ooa33d      number(20,6) DEFAULT '0',
ooa39       varchar2(10),            /*轉銷厂商                               */
ooa40       varchar2(2) DEFAULT ' '  /*单据类型                               */
);

create        index ooa_03 on ooa_file (ooa33);
create        index ooa_02 on ooa_file (ooa03);
alter table ooa_file add  constraint ooa_pk primary key  (ooa01) enable validate;
grant select on ooa_file to tiptopgp;
grant update on ooa_file to tiptopgp;
grant delete on ooa_file to tiptopgp;
grant insert on ooa_file to tiptopgp;
grant index on ooa_file to public;
grant select on ooa_file to ods;
