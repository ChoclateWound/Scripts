# SubDomainFinder.py is a script that find domains from certificate transparency logs.
# importing the requests library
import requests


def certspot():
    domain = input("Enter domainname: ")
    URL = "https://certspotter.com/api/v0/certs?domain="+domain

    r = requests.get(url=URL)



    data = r.json()
    count = 0
    with open('domains_found.txt', 'w') as f:
        for i in data:
            domains = data[count]['dns_names']#, data[count]['not_before'], data[count]['not_after']
            count +=1
            domains =str(domains)
            domains = domains.replace("['","")
            domains = domains.replace("', '", "\n")
            domains = domains.replace("']", "")
            f.write("%s\n" % str(domains))
            # print (domains)
        print("Found domain: ", count)


def main():
    certspot()


if __name__ == '__main__':
    main()
