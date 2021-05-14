### Install/upgrade

    helm upgrade --install --create-namespace module1 . -n dev &
    helm upgrade --install --create-namespace module1 . -n tst &
    helm upgrade --install --create-namespace module1 . -n acc &
    helm upgrade --install --create-namespace module1 . -n prd &

### Delete

    helm delete module1 -n dev &
    helm delete module1 -n tst &
    helm delete module1 -n acc &
    helm delete module1 -n prd &

